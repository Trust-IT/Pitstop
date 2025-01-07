//
//  EditVehicleView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 22/05/22.
//

import SwiftUI

struct EditVehicleView: View {
    @FocusState var focusedField: FocusFieldBoarding?
    @Environment(\.modelContext) private var modelContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State private var defaultFuelPicker: AlertConfig = .init(
        enableBackgroundBlur: false,
        disableOutsideTap: false,
        transitionType: .slide
    )
    @State private var secondaryFuelPicker: AlertConfig = .init(
        enableBackgroundBlur: false,
        disableOutsideTap: false,
        transitionType: .slide
    )
    @State private var isTapped = false
    @State private var isTapped2 = false

    var isDisabled: Bool {
        name.isEmpty || brand.isEmpty || model.isEmpty || mainFuelType == .none || mainFuelType == secondaryFuelType
    }

    var vehicle2: Vehicle

    @State private var name: String
    @State private var brand: String
    @State private var model: String
    @State private var plate: String
    @State private var mainFuelType: FuelType
    @State private var secondaryFuelType: FuelType

    init(vehicle2: Vehicle) {
        self.vehicle2 = vehicle2
        _name = State(initialValue: vehicle2.name)
        _brand = State(initialValue: vehicle2.brand)
        _model = State(initialValue: vehicle2.model)
        _plate = State(initialValue: vehicle2.plate ?? "")
        _mainFuelType = State(initialValue: vehicle2.mainFuelType)
        _secondaryFuelType = State(initialValue: vehicle2.secondaryFuelType ?? .none)
    }

    var body: some View {
        ZStack {
            Palette.greyBackground.ignoresSafeArea()
            VStack(spacing: 20) {
                TextField(String(localized: "Vehicle name"), text: $name)
                    .disableAutocorrection(true)
                    .focused($focusedField, equals: .carName)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                    .frame(width: UIScreen.main.bounds.size.width * 0.90, height: UIScreen.main.bounds.size.height * 0.055)
                    .background(focusedField == .carName ? Palette.greyLight : Palette.greyBackground)
                    .font(Typography.TextM)
                    .foregroundColor(Palette.black)
                    .cornerRadius(36)
                    .overlay(
                        RoundedRectangle(cornerRadius: 36)
                            .stroke(focusedField == .carName ? Palette.black : Palette.greyInput, lineWidth: 1)
                    )
                    .modifier(ClearButton(text: $name))
                    .onSubmit {
                        focusedField = .brand
                    }

                TextField(String(localized: "Brand"), text: $brand)
                    .disableAutocorrection(true)
                    .focused($focusedField, equals: .brand)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                    .frame(width: UIScreen.main.bounds.size.width * 0.90, height: UIScreen.main.bounds.size.height * 0.055)
                    .background(focusedField == .brand ? Palette.greyLight : Palette.greyBackground)
                    .font(Typography.TextM)
                    .foregroundColor(Palette.black)
                    .cornerRadius(36)
                    .overlay(
                        RoundedRectangle(cornerRadius: 36)
                            .stroke(focusedField == .brand ? Palette.black : Palette.greyInput, lineWidth: 1)
                    )
                    .modifier(ClearButton(text: $brand))
                    .onSubmit {
                        focusedField = .model
                    }

                TextField(String(localized: "Model"), text: $model)
                    .disableAutocorrection(true)
                    .focused($focusedField, equals: .model)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                    .frame(width: UIScreen.main.bounds.size.width * 0.90, height: UIScreen.main.bounds.size.height * 0.055)
                    .background(focusedField == .model ? Palette.greyLight : Palette.greyBackground)
                    .font(Typography.TextM)
                    .foregroundColor(Palette.black)
                    .cornerRadius(36)
                    .overlay(
                        RoundedRectangle(cornerRadius: 36)
                            .stroke(focusedField == .model ? Palette.black : Palette.greyInput, lineWidth: 1)
                    )
                    .modifier(ClearButton(text: $model))
                    .onSubmit {
                        focusedField = .plate
                    }

                TextField(String(localized: "Plate"), text: $plate)
                    .disableAutocorrection(true)
                    .focused($focusedField, equals: .plate)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                    .frame(width: UIScreen.main.bounds.size.width * 0.90, height: UIScreen.main.bounds.size.height * 0.055)
                    .background(focusedField == .plate ? Palette.greyLight : Palette.greyBackground)
                    .font(Typography.TextM)
                    .foregroundColor(Palette.black)
                    .cornerRadius(36)
                    .overlay(
                        RoundedRectangle(cornerRadius: 36)
                            .stroke(focusedField == .plate ? Palette.black : Palette.greyInput, lineWidth: 1)
                    )
                    .modifier(ClearButton(text: $plate))
                    .onSubmit {
                        focusedField = nil
                    }

                // MARK: DEFAULT FUEL TYPE

                Button(action: {
                    defaultFuelPicker.present()
                    isTapped.toggle()
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 36)
                            .stroke(isTapped ? Palette.black : Palette.greyInput, lineWidth: 1)
                            .background(isTapped ? Palette.greyLight : Palette.greyBackground)
                            .frame(width: UIScreen.main.bounds.size.width * 0.90, height: UIScreen.main.bounds.size.height * 0.055)
                        HStack {
                            Text(mainFuelType.rawValue)
                                .font(Typography.TextM)
                            Spacer()
                        }
                        .padding(.leading, 40)
                    }
                    .accentColor(Palette.black)
                })
                .alert(config: $defaultFuelPicker) {
                    ConfirmationDialog(
                        items: FuelType.allCases,
                        message: "Select a default fuel type",
                        onTap: { fuel in
                            isTapped = false
                            mainFuelType = fuel
                            defaultFuelPicker.dismiss()
                        },
                        onCancel: {
                            defaultFuelPicker.dismiss()
                        }
                    )
                }

                // MARK: SECONDARY FUEL TYPE

                Button(action: {
                    secondaryFuelPicker.present()
                    isTapped2.toggle()
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 36)
                            .stroke(isTapped2 ? Palette.black : Palette.greyInput, lineWidth: 1)
                            .background(isTapped2 ? Palette.greyLight : Palette.greyBackground)
                            .frame(width: UIScreen.main.bounds.size.width * 0.90, height: UIScreen.main.bounds.size.height * 0.055)
                        HStack {
                            Text(secondaryFuelType.rawValue)
                                .font(Typography.TextM)
                            Spacer()
                        }
                        .padding(.leading, 40)
                    }
                    .accentColor(Palette.black)
                })
                .alert(config: $secondaryFuelPicker) {
                    ConfirmationDialog(
                        items: FuelType.allCases,
                        message: "Select a second fuel type",
                        onTap: { fuel in
                            isTapped2 = false
                            secondaryFuelType = fuel
                            secondaryFuelPicker.dismiss()
                        },
                        onCancel: {
                            secondaryFuelPicker.dismiss()
                        }
                    )
                }
                Spacer()
            }
            .padding(.vertical, 30)
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading:
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image("arrowLeft")
                })
                .accentColor(Palette.greyHard),
                trailing:
                Button(action: {
                    updateVehicle(vehicle2)
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text(String(localized: "Save"))
                        .font(Typography.headerM)
                })
                .disabled(isDisabled)
                .opacity(isDisabled ? 0.6 : 1)
            )
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(name)
                        .font(Typography.headerM)
                        .foregroundColor(Palette.black)
                }
            }
        }
    }

    private func updateVehicle(_ vehicle: Vehicle) {
        vehicle.name = name
        vehicle.brand = brand
        vehicle.model = model
        vehicle.plate = plate
        vehicle.mainFuelType = mainFuelType
        vehicle.secondaryFuelType = secondaryFuelType

        do {
            try modelContext.save()
            print("Vehicle saved successfully!")
        } catch {
            print("Failed to save vehicle: \(error)")
        }
    }
}
