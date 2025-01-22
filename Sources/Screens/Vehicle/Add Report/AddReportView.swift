//
//  AddReportView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 06/05/22.
//

import SwiftUI

struct AddReportView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject var vehicleManager: VehicleManager

    @Environment(AppState.self) var appState: AppState

    @State private var showOdometerAlert = false
    @State private var showNotificationErrorAlert = false
    @State private var notificationRequestError : Error?
    @State private var showNotificationDeniedAlert = false

    @State private var reminder: Reminder = .mock()
    @State var fuelExpense: FuelExpense = .mock()
    @State var fuelCategories: [FuelType] = []

    @State private var fuelTotal: Float = 0.0

    // FIXME: Focus keyboard
    @FocusState var reminderInputFocus: ReminderInputFocusField?
    @FocusState var fuelInputFocus: FuelInputFocusField?

    @State private var currentPickerTab: NewReportTab = .fuel

    var body: some View {
        NavigationView {
            VStack {
                // MARK: Input fields

                switch currentPickerTab {
                case .reminder:
                    HStack {
                        Spacer()
                        TextField("-", text: $reminder.title)
                            .focused($reminderInputFocus, equals: .reminderTitle)
                            .textFieldStyle(InputTextFieldStyle())
                            .fixedSize(horizontal: true, vertical: true)
                        Spacer()
                    }
                    .padding(.top, 26)
                case .fuel:
                    HStack {
                        Spacer()
                        TextField("0,0", value: $fuelTotal, formatter: NumberFormatter.twoDecimalPlaces)
                            .keyboardType(.decimalPad)
                            .focused($fuelInputFocus, equals: .totalPrice)
                            .textFieldStyle(InputTextFieldStyle())
                            .fixedSize(horizontal: true, vertical: true)
                        Text(appState.currency)
                            .font(Typography.headerXXL)
                            .foregroundColor(Palette.black)
                        Spacer()
                    }
                    .padding(.top, 26)
                }

                SegmentedPicker(currentTab: $currentPickerTab, onTap: {})
                    .padding(.horizontal, 32)
                    .padding(.top, 24)

                // MARK: List

                switch currentPickerTab {
                case .reminder:
                    ReminderInputView(reminder: reminder, reminderInputFocus: $reminderInputFocus)

                case .fuel:
                    FuelExpenseInputView(
                        vehicleFuels: fuelCategories,
                        fuelInputFocus: $fuelInputFocus,
                        fuelExpense: fuelExpense
                    )
                    .onAppear {
                        fuelInputFocus = .totalPrice
                        // Reset the reminder when switching tabs
                        reminder = .mock()
                    }
                }
            }
            .background(Palette.greyBackground)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading:
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Cancel")
                        .font(Typography.headerM)
                })
                .accentColor(Palette.greyHard),
                trailing:
                Button(
                    action: {
                        switch currentPickerTab {
                        case .reminder:
                            createReminderNotification()
                        case .fuel:
                            if fuelExpense.isValidOdometer(for: vehicleManager.currentVehicle) {
                                if fuelExpense.odometer > vehicleManager.currentVehicle.odometer {
                                    vehicleManager.currentVehicle.odometer = fuelExpense.odometer
                                }

                                fuelExpense.totalPrice = fuelTotal
                                vehicleManager.currentVehicle.fuelExpenses.append(fuelExpense)
                                fuelExpense.insert(context: modelContext)
                                presentationMode.wrappedValue.dismiss()
                            } else {
                                showOdometerAlert.toggle()
                            }
                        }
                    },
                    label: {
                        Text(String(localized: "Save"))
                            .font(Typography.headerM)
                    }
                )
                .disabled(reminder.title.isEmpty && (fuelTotal.isZero || fuelExpense.quantity.isZero))
                .opacity(reminder.title.isEmpty && (fuelTotal.isZero || fuelExpense.quantity.isZero) ? 0.6 : 1)
            )
            .toolbar {
                /// Keyboard focus
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Button(action: {
                            switch currentPickerTab {
                            case .reminder:
                                reminderInputFocus = nil
                            case .fuel:
                                fuelInputFocus = nil
                            }
                        }, label: {
                            Image(systemName: "keyboard.chevron.compact.down")
                                .resizable()
                                .foregroundColor(Palette.black)
                        })
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text(String(localized: "New report"))
                        .font(Typography.headerM)
                        .foregroundColor(Palette.black)
                }
            }
            .alert(isPresented: $showOdometerAlert) {
                Alert(
                    title: Text("Attention"),
                    message: Text("Can't set this odometer value for the specific timerframe, make sure it's correct")
                )
            }
        }
        .onAppear {
            initializeFuelExpense()
        }
    }

    private func initializeFuelExpense() {
        let currentVehicle = vehicleManager.currentVehicle
        fuelExpense = FuelExpense(
            totalPrice: 0.0,
            quantity: 0,
            pricePerUnit: 0.0,
            odometer: currentVehicle.odometer,
            fuelType: currentVehicle.mainFuelType,
            date: Date(),
            vehicle: nil
        )

        fuelCategories.append(currentVehicle.mainFuelType)
        guard let secondaryFuelType = currentVehicle.secondaryFuelType else { return }
        fuelCategories.append(secondaryFuelType)
    }
}

private extension AddReportView {
    func createReminderNotification() {
        Task {
            do {
                let status = try await NotificationManager.shared.requestAuthNotifications()
                
                guard status == .authorized else {
                    showNotificationDeniedAlert.toggle()
                    return
                }
                
                await NotificationManager.shared.createNotification(for: ReminderNotificationData(from: reminder))
                
                try reminder.saveToModelContext(context: modelContext)
                
                navManager.pop()
            } catch {
                notificationRequestError = error
                showNotificationErrorAlert.toggle()
            }
        }
    }
}

enum NewReportTab: String, CaseIterable, Identifiable {
    case fuel
    case reminder

    var id: Self { self }
}

// MARK: - Focus fields

enum ReminderInputFocusField: Hashable {
    case reminderTitle
    case note
}

enum FuelInputFocusField: Hashable {
    case totalPrice
    case odometer
    case quantity
    case pricePerUnit
}
