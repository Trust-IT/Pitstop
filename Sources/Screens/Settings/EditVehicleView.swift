//
//  EditVehicleView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 22/05/22.
//

import SwiftData
import SwiftUI

struct EditVehicleView: View {
    @EnvironmentObject private var navManager: NavigationManager
    @EnvironmentObject var vehicleManager: VehicleManager
    @FocusState var focusedField: VehicleInfoFocusField?
    @Environment(\.modelContext) private var modelContext
    @Environment(AppState.self) var appState: AppState

    @State private var defaultFuelPicker: AlertConfig = .init(
        enableBackgroundBlur: true,
        disableOutsideTap: false,
        transitionType: .slide
    )
    @State private var secondaryFuelPicker: AlertConfig = .init(
        enableBackgroundBlur: true,
        disableOutsideTap: false,
        transitionType: .slide
    )
    var isDisabled: Bool {
        name.isEmpty ||
            brand.isEmpty ||
            model.isEmpty ||
            mainFuelType == .none ||
            mainFuelType == secondaryFuelType
    }

    @State private var showDeleteAlert: Bool = false

    @Query
    var vehicles: [Vehicle]

    @Bindable var vehicle: Vehicle

    @State private var name: String
    @State private var brand: String
    @State private var model: String
    @State private var plate: String
    @State private var mainFuelType: FuelType
    @State private var secondaryFuelType: FuelType

    init(vehicle: Vehicle) {
        self.vehicle = vehicle
        _name = State(initialValue: vehicle.name)
        _brand = State(initialValue: vehicle.brand)
        _model = State(initialValue: vehicle.model)
        _plate = State(initialValue: vehicle.plate ?? "")
        _mainFuelType = State(initialValue: vehicle.mainFuelType)
        _secondaryFuelType = State(initialValue: vehicle.secondaryFuelType ?? .none)
    }

    var body: some View {
        VStack(spacing: 16) {
            ScrollView {
                VStack(spacing: 20) {
                    TextField(PitstopAPPStrings.Onb.vehicleName, text: $name)
                        .textFieldStyle(BoxTextFieldStyle(focusedField: $focusedField, field: .vehicleName))
                        .onSubmit {
                            focusedField = .brand
                        }

                    TextField(PitstopAPPStrings.Onb.brand, text: $brand)
                        .textFieldStyle(BoxTextFieldStyle(focusedField: $focusedField, field: .brand))
                        .onSubmit {
                            focusedField = .model
                        }

                    TextField(PitstopAPPStrings.Onb.model, text: $model)
                        .textFieldStyle(BoxTextFieldStyle(focusedField: $focusedField, field: .model))
                        .onSubmit {
                            focusedField = .plate
                        }

                    TextField(PitstopAPPStrings.Onb.plateNumber, text: $plate)
                        .textFieldStyle(BoxTextFieldStyle(focusedField: $focusedField, field: .plate))
                        .onSubmit {
                            focusedField = nil
                        }

                    TextField("Main Fuel Type", text: fuelTypeBinding(for: $mainFuelType))
                        .textFieldStyle(BoxTextFieldStyle(focusedField: $focusedField, field: .fuelType))
                        .disabled(true)
                        .onTapGesture {
                            focusedField = nil
                            defaultFuelPicker.present()
                        }
                        .alert(config: $defaultFuelPicker) {
                            ConfirmationDialog(
                                items: FuelType.allCases,
                                message: "Select a default fuel type",
                                onTap: { fuel in
                                    mainFuelType = fuel
                                    defaultFuelPicker.dismiss()
                                },
                                onCancel: {
                                    defaultFuelPicker.dismiss()
                                }
                            )
                        }

                    TextField(PitstopAPPStrings.Onb.secondFuelType, text: fuelTypeBinding(for: $secondaryFuelType))
                        .textFieldStyle(BoxTextFieldStyle(focusedField: $focusedField, field: .fuelType))
                        .disabled(true)
                        .onTapGesture {
                            focusedField = nil
                            secondaryFuelPicker.present()
                        }
                        .alert(config: $secondaryFuelPicker) {
                            ConfirmationDialog(
                                items: FuelType.allCases,
                                message: "Select a second fuel type",
                                onTap: { fuel in
                                    secondaryFuelType = fuel
                                    secondaryFuelPicker.dismiss()
                                },
                                onCancel: {
                                    secondaryFuelPicker.dismiss()
                                }
                            )
                        }
                }
                .padding(.horizontal, 16)
            }
            Spacer()
            if vehicleManager.currentVehicle != vehicle {
                Button("Set as current vehicle") {
                    vehicleManager.setCurrentVehicle(vehicle)
                    navManager.pop()
                }
                .buttonStyle(Primary())
            }
            if vehicles.count > 1 {
                Button(action: {
                    showDeleteAlert.toggle()
                }, label: {
                    DeleteButton(title: "Delete vehicle")
                })
                .buttonStyle(Secondary())
            }
        }
        .padding(.top, 24)
        .background(Palette.greyBackground)
        .alert(isPresented: $showDeleteAlert) {
            Alert(
                title: Text("Are you sure you want to delete this vehicle?"),
                message: Text("This action cannot be undone"),
                primaryButton: .destructive(Text(PitstopAPPStrings.Common.delete)) {
                    modelContext.delete(vehicle)
                    vehicleManager.setCurrentVehicle(vehicles.first ?? .mock())
                    navManager.pop()
                },
                secondaryButton: .cancel()
            )
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(name)
                    .font(Typography.headerM)
                    .foregroundColor(Palette.black)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    updateVehicle(vehicle)
                    navManager.pop()
                }, label: {
                    Text(PitstopAPPStrings.Common.save)
                        .font(Typography.headerM)
                        .foregroundStyle(appState.currentTheme.accentColor)
                })
                .disabled(isDisabled)
                .opacity(isDisabled ? 0.6 : 1)
            }
        }
    }
}

private extension EditVehicleView {
    func updateVehicle(_ vehicle: Vehicle) {
        vehicle.name = name
        vehicle.brand = brand
        vehicle.model = model
        vehicle.plate = plate
        vehicle.mainFuelType = mainFuelType
        vehicle.secondaryFuelType = secondaryFuelType
    }

    func fuelTypeBinding(for fuelType: Binding<FuelType>) -> Binding<String> {
        Binding(
            get: { fuelType.wrappedValue.rawValue },
            set: { newValue in
                if let newFuelType = FuelType(rawValue: newValue) {
                    fuelType.wrappedValue = newFuelType
                }
            }
        )
    }
}

#Preview {
    EditVehicleView(vehicle: Vehicle.mock())
}
