//
//  FuelReportView.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 23/01/25.
//

import ChassisUI
import NavigatorUI
import PitstopData
import SwiftUI

struct FuelReportView: View {
    @Environment(VehicleManager.self) var vehicleManager: VehicleManager
    @Environment(\.navigator) private var navigator
    @Environment(AppState.self) var appState: AppState

    @FocusState private var focusState: FuelInputFocusField?
    @State private var totalPrice: Decimal
    @State private var odometer: Int
    @State private var liters: Double
    @State private var fuelType: FuelType = .diesel
    @State private var selectedDate = Date()
    @State private var alert = AlertConfig(enableBackgroundBlur: true,
                                           disableOutsideTap: false)
    @State private var odometerError: OdometerValidationError?

    let fuelExpense: FuelExpense
    init(fuelExpense: FuelExpense) {
        self.fuelExpense = fuelExpense
        _totalPrice = State(initialValue: fuelExpense.totalCost)
        _odometer = State(initialValue: fuelExpense.odometer)
        _liters = State(initialValue: Double(fuelExpense.quantity))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                FuelInputTextField(
                    title: "Total",
                    placeholder: appState.currency.format(fuelExpense.totalCost),
                    measurement: appState.currency.identifier,
                    icon: ChassisUIAsset.category,
                    focusState: $focusState,
                    focus: .totalPrice,
                    value: $totalPrice,
                    format: .number
                )
                FuelInputTextField(
                    title: "Odometer",
                    placeholder: "\(vehicleManager.currentVehicle.currentOdometer)",
                    measurement: appState.measurementUnit.symbol,
                    icon: ChassisUIAsset.odometer,
                    focusState: $focusState,
                    focus: .odometer,
                    value: $odometer,
                    format: .number,
                    keyboardType: .numberPad
                )
                FuelInputTextField(
                    title: "Liters",
                    placeholder: "\(fuelExpense.quantity)",
                    measurement: appState.volumeUnit.symbol,
                    icon: ChassisUIAsset.liters,
                    focusState: $focusState,
                    focus: .quantity,
                    value: $liters,
                    format: .number
                )
            }
        }
        .safeAreaInset(edge: .bottom) {
            Button(PitstopStrings.Localizable.Common.save) {
                saveExpense()
            }
            .disabled(!areFieldsValid)
            .buttonStyle(Primary())
            .padding(.bottom, 12)
        }
        .onAppear {
            focusState = .totalPrice
            // vehicleManager doesn't exist during init (EnvObj), so set fuelType here
            fuelType = vehicleManager.currentVehicle.mainFuelType
        }
        .alert(config: $alert) {
            VStack {
                DatePicker("", selection: $selectedDate, in: ...Date(), displayedComponents: [.date])
                    .datePickerStyle(.graphical)
                    .labelsHidden()
                    .accentColor(appState.currentTheme.accentColor)
            }
            .background(RoundedRectangle(cornerRadius: 16).fill(Palette.white))
            .padding()
        }
        .navigationTitle("New report")
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .alert(
            "Invalid Odometer",
            isPresented: Binding(get: { odometerError != nil }, set: { _ in odometerError = nil }),
            actions: { Button("OK") { odometerError = nil } },
            message: { Text(odometerError?.errorDescription ?? "") }
        )
        .background(Palette.greyBackground.ignoresSafeArea(.all))
        .toolbar {
            navigationItems()
        }
    }
}

private extension FuelReportView {
    func nextFieldFor(_ current: FuelInputFocusField) {
        if current == .totalPrice {
            focusState = .odometer
        } else if current == .odometer {
            focusState = .quantity
        } else if current == .quantity {
            focusState = .totalPrice
        }
    }

    func saveExpense() {
        if let error = vehicleManager.validateOdometer(odometer, for: selectedDate) {
            odometerError = error
            return
        }
        fuelExpense.totalCost = totalPrice
        fuelExpense.odometer = odometer
        fuelExpense.quantity = Float(liters)
        fuelExpense.fuelType = fuelType
        fuelExpense.date = selectedDate
        fuelExpense.vehicle = vehicleManager.currentVehicle
        vehicleManager.saveFuelExpense(fuelExpense)
        navigator.back()
    }

    var areFieldsValid: Bool {
        totalPrice > 0 && odometer > 0 && liters > 0
    }
}

private extension FuelReportView {
    @ToolbarContentBuilder
    func navigationItems() -> some ToolbarContent {
        // TODO: CHECK IF REMOVE FOCUS STATE
//        if let focus = focusState {
//            ToolbarItem(placement: .keyboard) {
//                HStack {
//                    Button(action: {
//                        focusState = nil
//                    }, label: {
//                        Image(systemName: "keyboard.chevron.compact.down")
//                    })
//                    Spacer()
//                    Button(action: {
//                        nextFieldFor(focus)
//                    }, label: {
//                        Text("Next")
//                            .foregroundStyle(Palette.black)
//                            .font(Typography.headerM)
//                    })
//                }
//            }
//        }
        ToolbarItem(placement: .navigation) {
            Button(action: {
                navigator.dismiss()
            }, label: {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Palette.black)
            })
        }
        ToolbarItemGroup(placement: .topBarTrailing) {
            HStack {
                Button(action: {
                    focusState = nil
                    alert.present()
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }, label: {
                    HStack {
                        ChassisUIAsset.day.swiftUIImage
                            .resizable()
                            .frame(width: 16, height: 16)
                            .tint(Palette.black)
                        Text(selectedDate.formatDate(with: "dd MMM YYYY"))
                            .fixedSize()
                    }
                    .padding(8)
                })
                .buttonStyle(SecondaryCapsule())
            }
        }
    }
}

#Preview {
    @Previewable @State var vehicleManager = PreviewSupport.vehicleManager
    ManagedNavigationStack {
        FuelReportView(fuelExpense: FuelExpense.mock())
            .environment(vehicleManager)
            .environment(AppState())
    }
}
