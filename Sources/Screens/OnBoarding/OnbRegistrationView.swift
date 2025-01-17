//
//  OnbRegistrationView.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 16/01/25.
//

import SwiftUI

struct OnbRegistrationView: View {
    @EnvironmentObject private var navManager: NavigationManager
    @FocusState var focusedField: FocusFieldOnboarding?

    @State private var showMainFuelSelection: AlertConfig = .init(
        enableBackgroundBlur: true,
        disableOutsideTap: false,
        transitionType: .slide
    )

    @State private var inputData = OnbVehicleInputData()

    var body: some View {
        VStack {
            Spacer(minLength: 60)
            VStack(spacing: 12) {
                Text("Vehicle registration")
                    .font(Typography.headerXL)
                    .foregroundColor(Palette.black)
                Text("Hop in and insert some key details")
                    .font(Typography.TextM)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Palette.black)
            }
            VStack(spacing: 20) {
                TextField("Vehicle name", text: $inputData.name)
                    .textFieldStyle(BoxTextFieldStyle(focusedField: $focusedField, field: .vehicleName))
                    .onSubmit {
                        focusedField = .brand
                    }
                TextField("Brand", text: $inputData.brand)
                    .textFieldStyle(BoxTextFieldStyle(focusedField: $focusedField, field: .brand))
                    .onSubmit {
                        focusedField = .model
                    }
                TextField("Model", text: $inputData.model)
                    .textFieldStyle(BoxTextFieldStyle(focusedField: $focusedField, field: .model))
                    .onSubmit {
                        focusedField = .fuelType
                    }
                TextField("Fuel Type", text: fuelTypeBinding)
                    .textFieldStyle(BoxTextFieldStyle(focusedField: $focusedField, field: .fuelType))
                    .disabled(true)
                    .onTapGesture {
                        focusedField = nil
                        showMainFuelSelection.present()
                    }
                    .alert(config: $showMainFuelSelection) {
                        ConfirmationDialog(
                            items: FuelType.allCases,
                            message: "Select a fuel type",
                            onTap: { fuel in
                                inputData.fuelType = fuel
                                focusedField = nil
                                showMainFuelSelection.dismiss()
                            },
                            onCancel: {
                                focusedField = nil
                                showMainFuelSelection.dismiss()
                            }
                        )
                    }
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 56)

            Spacer()
            Button(action: {
                withAnimation(.easeInOut) {
                    navManager.push(.onboardingMoreInfo(input: inputData))
                }
            }, label: {
                Text("Next")
            })
            .buttonStyle(Primary())
            .padding(.bottom, 32)
            .disabled(inputData.isEmpty())
        }
        .ignoresSafeArea(.keyboard)
        .background(Palette.greyBackground)
        .onTapGesture {
            focusedField = nil
        }
        .onAppear {
            if inputData.name.isEmpty {
                focusedField = .vehicleName
            }
        }
    }

    private var fuelTypeBinding: Binding<String> {
        Binding(
            get: { inputData.fuelType.rawValue },
            set: { newValue in
                if let fuelType = FuelType(rawValue: newValue) {
                    inputData.fuelType = fuelType
                }
            }
        )
    }
}

struct OnbVehicleInputData: Equatable {
    var name: String = ""
    var brand: String = ""
    var model: String = ""
    var fuelType: FuelType = .none

    func isEmpty() -> Bool {
        name.isEmpty || model.isEmpty || model.isEmpty || fuelType == .none
    }
}

#Preview {
    OnbRegistrationView()
        .environmentObject(NavigationManager())
}
