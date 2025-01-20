//
//  EditVehicleView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 22/05/22.
//

import SwiftUI

struct EditVehicleView: View {
    @FocusState var focusedField: VehicleInfoFocusField?
    @Environment(\.modelContext) private var modelContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

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
        VStack(spacing: 20) {
            ScrollView {
                TextField(String(localized: "Vehicle name"), text: $name)
                    .textFieldStyle(BoxTextFieldStyle(focusedField: $focusedField, field: .vehicleName))
                    .onSubmit {
                        focusedField = .brand
                    }
                
                TextField(String(localized: "Brand"), text: $brand)
                    .textFieldStyle(BoxTextFieldStyle(focusedField: $focusedField, field: .brand))
                    .onSubmit {
                        focusedField = .model
                    }
                
                TextField(String(localized: "Model"), text: $model)
                    .textFieldStyle(BoxTextFieldStyle(focusedField: $focusedField, field: .model))
                    .onSubmit {
                        focusedField = .plate
                    }
                
                TextField(String(localized: "Plate"), text: $plate)
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
                
                TextField("Secondary Fuel Type", text: fuelTypeBinding(for: $secondaryFuelType))
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
        }
        .padding(.horizontal, 16)
        .padding(.top, 24)
        .background(Palette.greyBackground)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(name)
                    .font(Typography.headerM)
                    .foregroundColor(Palette.black)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    updateVehicle(vehicle)
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text(String(localized: "Save"))
                        .font(Typography.headerM)
                        .foregroundStyle(Palette.accent)
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
