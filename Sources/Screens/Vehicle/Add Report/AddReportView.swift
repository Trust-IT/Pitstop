//
//  AddReportView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 06/05/22.
//

import SwiftUI

struct AddReportView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var vehicleManager: VehicleManager
    @EnvironmentObject var navManager: NavigationManager

    @Environment(AppState.self) var appState: AppState

    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""

    @State private var reminder: Reminder = .mock()
    @State var fuelExpense: FuelExpense = .mock()
    @State var fuelCategories: [FuelType] = []

    @State private var fuelTotal: Float = 0.0

    // FIXME: Focus keyboard
    @FocusState var reminderInputFocus: ReminderInputFocusField?
    @FocusState var fuelInputFocus: FuelInputFocusField?

    @State private var currentPickerTab: NewReportTab = .fuel

    var body: some View {
        VStack {
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
        .toolbar {
            // Cancel button
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    navManager.pop()
                }, label: {
                    Text("Cancel")
                        .font(Typography.headerM)
                })
                .accentColor(Palette.greyHard)
            }
            
            // Save button
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    switch currentPickerTab {
                    case .reminder:
                        createReminderNotification()
                    case .fuel:
                        createFuelExpense()
                    }
                },label: {
                    Text(String(localized: "Save"))
                        .font(Typography.headerM)
                })
                .disabled(reminder.title.isEmpty && (fuelTotal.isZero || fuelExpense.quantity.isZero))
                .opacity(reminder.title.isEmpty && (fuelTotal.isZero || fuelExpense.quantity.isZero) ? 0.6 : 1)
            }
            
            // Dismiss keyboard button (keyboard toolbar)
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
        .alert(alertTitle,
               isPresented: $showAlert,
               actions: {},
               message: { Text(alertMessage)})
        .onAppear {
            initializeFuelExpense()
        }
    }
}

private extension AddReportView {
    
    func showAlert(with title: String,and message: String) {
        showAlert.toggle()
        alertTitle = title
        alertMessage = message
    }
    
    func createReminderNotification() {
        Task {
            do {
                let status = try await NotificationManager.shared.requestAuthNotifications()
                
                guard status == .authorized else {
                    showAlert(with: "Attention", and: "Enable the notifications in the settings before creating a reminder")
                    return
                }
                
                await NotificationManager.shared.createNotification(for: ReminderNotificationData(from: reminder))
                
                try reminder.saveToModelContext(context: modelContext)
                
                navManager.pop()
            } catch {
                showAlert(with: "Error", and: error.localizedDescription)
            }
        }
    }
    
    func createFuelExpense() {
        if fuelExpense.isValidOdometer(for: vehicleManager.currentVehicle) {
            if fuelExpense.odometer > vehicleManager.currentVehicle.odometer {
                vehicleManager.currentVehicle.odometer = fuelExpense.odometer
            }
            
//            fuelExpense.totalPrice = fuelTotal
            vehicleManager.currentVehicle.fuelExpenses.append(fuelExpense)
            fuelExpense.insert(context: modelContext)
            navManager.pop()
        } else {
            showAlert(with: "Attention", and: "The odometer value is lower than the last report")
        }
    }
    
    func initializeFuelExpense() {
        let currentVehicle = vehicleManager.currentVehicle
        fuelExpense = FuelExpense(
            totalPrice: .init(value: 0.0),
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
