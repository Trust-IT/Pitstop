//
//  EditVehicleView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 22/05/22.
//

import SwiftData
import SwiftUI

private enum EditVehicleFocusField: Hashable {
    case brand, model, plate, fuelType
}

struct EditVehicleView: View {
    @EnvironmentObject private var navManager: NavigationManager
    @Environment(VehicleManager.self) var vehicleManager: VehicleManager
    @FocusState private var focusedField: EditVehicleFocusField?
    @Environment(\.modelContext) private var modelContext
    @Environment(AppState.self) var appState: AppState

    @State private var defaultFuelPicker: AlertConfig = .init(
        enableBackgroundBlur: true,
        disableOutsideTap: false,
        transitionType: .slide
    )
    var isDisabled: Bool {
        brand.isEmpty ||
            model.isEmpty ||
            mainFuelType == .none
    }

    @State private var showDeleteAlert: Bool = false

    @Query
    var vehicles: [Vehicle]

    @Bindable var vehicle: Vehicle

    @State private var brand: String
    @State private var model: String
    @State private var plate: String
    @State private var mainFuelType: FuelType

    init(vehicle: Vehicle) {
        self.vehicle = vehicle
        _brand = State(initialValue: vehicle.brand)
        _model = State(initialValue: vehicle.model)
        _plate = State(initialValue: vehicle.plate ?? "")
        _mainFuelType = State(initialValue: vehicle.mainFuelType)
    }

    var body: some View {
        VStack(spacing: 16) {
            ScrollView {
                VStack(spacing: 20) {
                    TextField(PitstopStrings.Localizable.Onb.brand, text: $brand)
                        .boxFieldStyle(focusedField: $focusedField, field: .brand)
                        .onSubmit {
                            focusedField = .model
                        }

                    TextField(PitstopStrings.Localizable.Onb.model, text: $model)
                        .boxFieldStyle(focusedField: $focusedField, field: .model)
                        .onSubmit {
                            focusedField = .plate
                        }

                    TextField(PitstopStrings.Localizable.Onb.plateNumber, text: $plate)
                        .boxFieldStyle(focusedField: $focusedField, field: .plate)
                        .onSubmit {
                            focusedField = nil
                        }

                    TextField("Main Fuel Type", text: fuelTypeBinding(for: $mainFuelType))
                        .boxFieldStyle(focusedField: $focusedField, field: .fuelType)
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
                }
                .padding(.horizontal, 16)
            }
            Spacer()
            if vehicleManager.currentVehicle != vehicle {
                Button("Set as current vehicle") {
                    vehicleManager.setCurrentVehicle(vehicle, modelContext: modelContext)
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
                primaryButton: .destructive(Text(PitstopStrings.Localizable.Common.delete)) {
                    modelContext.delete(vehicle)
                    vehicleManager.setCurrentVehicle(vehicles.first ?? .mock(), modelContext: modelContext)
                    navManager.pop()
                },
                secondaryButton: .cancel()
            )
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("\(brand) \(model)")
                    .font(Typography.headerM)
                    .foregroundColor(Palette.black)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    updateVehicle(vehicle)
                    navManager.pop()
                }, label: {
                    Text(PitstopStrings.Localizable.Common.save)
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
        vehicle.brand = brand
        vehicle.model = model
        vehicle.plate = plate
        vehicle.mainFuelType = mainFuelType
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
