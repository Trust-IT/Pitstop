//
//  OnboardingVehicleRegistrationView.swift
//  Pitstop-APP
//

import ChassisUI
import PitstopData
import SwiftUI

enum VehicleInfoFocusField: Hashable {
    case brand
    case model
    case fuelType
}

struct OnboardingVehicleRegistrationView: View {
    @Binding var inputData: OnboardingVehicleInputData
    @FocusState var focusedField: VehicleInfoFocusField?

    @State private var showMainFuelSelection: AlertConfig = .init(
        enableBackgroundBlur: true,
        disableOutsideTap: false,
        transitionType: .slide
    )

    var body: some View {
        VStack(spacing: 32) {
            VStack(spacing: 12) {
                Text(PitstopStrings.Localizable.Onb.vehicleRegistration)
                    .font(Typography.headerXL)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Palette.black)
                Text(PitstopStrings.Localizable.Onb.hopIn)
                    .font(Typography.TextM)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Palette.black)
            }
            .padding(.horizontal, 24)

            VStack(spacing: 20) {
                TextField(PitstopStrings.Localizable.Onb.brand, text: $inputData.brand)
                    .boxFieldStyle(focusedField: $focusedField, field: .brand)
                    .onSubmit { focusedField = .model }
                TextField(PitstopStrings.Localizable.Onb.model, text: $inputData.model)
                    .boxFieldStyle(focusedField: $focusedField, field: .model)
                    .onSubmit { focusedField = .fuelType }
                TextField(PitstopStrings.Localizable.Onb.fuelType, text: fuelTypeBinding)
                    .boxFieldStyle(focusedField: $focusedField, field: .fuelType)
                    .disabled(true)
                    .onTapGesture {
                        focusedField = nil
                        showMainFuelSelection.present()
                    }
                    .alert(config: $showMainFuelSelection) {
                        ConfirmationDialog(
                            items: FuelType.allCases,
                            message: PitstopStrings.Localizable.Onb.selectFuelType,
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
            }
            .padding(.horizontal, 16)
            Spacer()
        }
        .ignoresSafeArea(.keyboard)
        .background(Palette.greyBackground)
        .onTapGesture { focusedField = nil }
        .onAppear {
            if inputData.brand.isEmpty { focusedField = .brand }
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

struct OnboardingVehicleInputData: Equatable {
    var brand: String = ""
    var model: String = ""
    var fuelType: FuelType = .none

    func isEmpty() -> Bool {
        brand.isEmpty || model.isEmpty || fuelType == .none
    }
}

#Preview {
    @Previewable @State var inputData = OnboardingVehicleInputData()
    OnboardingVehicleRegistrationView(inputData: $inputData)
}
