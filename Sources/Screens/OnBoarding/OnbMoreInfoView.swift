//
//  OnbMoreInfoView.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 16/01/25.
//

import SwiftData
import SwiftUI

struct OnbMoreInfoView: View {
    @EnvironmentObject private var navManager: NavigationManager
    @EnvironmentObject var vehicleManager: VehicleManager
    @Environment(\.modelContext) private var modelContext
    @Environment(AppState.self) private var appState
    @FocusState fileprivate var focusedField: FocusFieldAlertOB?

    @State private var showPlateInput: AlertConfig = .init(
        enableBackgroundBlur: true,
        disableOutsideTap: false,
        transitionType: .slide
    )

    @State private var showOdometerInput: AlertConfig = .init(
        enableBackgroundBlur: true,
        disableOutsideTap: false,
        transitionType: .slide
    )

    @State private var showSecondaryFuelSelection: AlertConfig = .init(
        enableBackgroundBlur: true,
        disableOutsideTap: false,
        transitionType: .slide
    )

    @State private var secondaryFuelType: FuelType?
    @State private var odometer: Float = 0.0
    @State private var plate: String = ""

    let input: OnbVehicleInputData

    var body: some View {
        VStack {
            Spacer(minLength: 60)
            VStack(spacing: 12) {
                Text(PitstopAPPStrings.Onb.moreInfo)
                    .font(Typography.headerXL)
                    .foregroundColor(Palette.black)
                Text(PitstopAPPStrings.Onb.vehicleInfo)
                    .font(Typography.TextM)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Palette.black)
            }
            ScrollView(showsIndicators: false) {
                Button(action: {
                    showPlateInput.present()
                }, label: {
                    moreInfoCard(text: PitstopAPPStrings.Onb.plateNumber,
                                 bgColor: appState.currentTheme.colors.background,
                                 iconName: .star)
                })
                if !plate.isEmpty {
                    cardInput(value: plate)
                }
                Button(action: {
                    showOdometerInput.present()
                }, label: {
                    moreInfoCard(text: PitstopAPPStrings.Common.odometer,
                                 bgColor: appState.currentTheme.colors.background,
                                 iconName: .odometer)
                })
                if odometer != 0.0 {
                    cardInput(value: String(odometer))
                }
                Button(action: {
                    showSecondaryFuelSelection.present()
                }, label: {
                    moreInfoCard(text: PitstopAPPStrings.Onb.secondFuelType,
                                 bgColor: appState.currentTheme.colors.background,
                                 iconName: .fuel)
                })
                if let secondaryFuelType {
                    cardInput(value: secondaryFuelType.rawValue)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 56)
            Spacer()
            Button(action: {
                addVehicle()
                if appState.isAddingNewVehicle {
                    navManager.push(.onboardingReady)
                } else {
                    navManager.push(.onboardingNotification)
                }
            }, label: {
                Text(PitstopAPPStrings.Onb.addVehicle)
            })
            .buttonStyle(Primary())
            .padding(.bottom, 32)
        }
        .background(Palette.greyBackground)
        .alert(config: $showPlateInput) {
            PlateInputAlert(plateNumber: $plate, showPlateInput: $showPlateInput)
        }
        .alert(config: $showOdometerInput) {
            OdometerInputAlert(odometer: $odometer, showOdometerInput: $showOdometerInput)
        }
        .alert(config: $showSecondaryFuelSelection) {
            ConfirmationDialog(
                items: FuelType.allCases,
                message: PitstopAPPStrings.Onb.selectFuelType,
                onTap: { value in
                    secondaryFuelType = value
                    showSecondaryFuelSelection.dismiss()
                },
                onCancel: {
                    showSecondaryFuelSelection.dismiss()
                }
            )
        }
    }

    private func addVehicle() {
        let vehicle = Vehicle(
            name: input.name,
            brand: input.brand,
            model: input.model,
            mainFuelType: input.fuelType,
            secondaryFuelType: secondaryFuelType,
            odometer: odometer,
            plate: plate
        )
        do {
            try vehicle.saveToModelContext(context: modelContext)
        } catch {
            print("[Debug] Onboarding add vehicle: \(error)")
        }
        vehicleManager.setCurrentVehicle(vehicle)
    }
}

// MARK: Additional Views

private extension OnbMoreInfoView {
    @ViewBuilder
    func moreInfoCard(
        text: String,
        bgColor: Color,
        iconName: ImageResource
    ) -> some View {
        ZStack {
            Rectangle()
                .frame(height: 68, alignment: .center)
                .cornerRadius(12)
                .foregroundColor(Palette.white)
                .shadowGrey()
            HStack {
                ZStack {
                    Circle()
                        .foregroundColor(bgColor)
                        .frame(width: 32, height: 32)
                    Image(iconName)
                        .resizable()
                        .tint(appState.currentTheme.accentColor)
                        .frame(width: 16, height: 16)
                }
                Text(text)
                    .foregroundColor(Palette.black)
                    .font(Typography.headerM)
                Spacer()
            }
            .padding(.horizontal, 15)
        }
    }

    @ViewBuilder
    func cardInput(value: String) -> some View {
        ZStack {
            Rectangle()
                .foregroundColor(Palette.greyLight)
                .cornerRadius(12)

            HStack {
                Text(value)
                    .font(Typography.ControlS)
                    .foregroundColor(Palette.black)
                Spacer()
            }
            .padding(.horizontal, 15)
        }
        .frame(height: 64)
    }
}

private extension OnbMoreInfoView {
    struct PlateInputAlert: View {
        @Binding var plateNumber: String
        @Binding var showPlateInput: AlertConfig
        @FocusState private var focusedField: FocusFieldAlertOB?

        var body: some View {
            VStack(spacing: 16) {
                HStack {
                    Spacer()
                    Text(PitstopAPPStrings.Onb.writePlate)
                        .foregroundColor(Palette.black)
                        .font(Typography.headerM)
                        .padding(.leading, 40)
                    Spacer()
                    Button(action: {
                        showPlateInput.dismiss()
                    }, label: {
                        ZStack {
                            Circle()
                                .frame(width: 24, height: 24)
                                .foregroundColor(Palette.greyLight)
                            Image(.ics)
                        }
                        .foregroundColor(Palette.black)
                        .padding(.trailing, 20)
                    })
                }
                VStack(spacing: 12) {
                    TextField("DX390XX", text: $plateNumber)
                        .textFieldStyle(BoxTextFieldStyle(focusedField: $focusedField, field: .plate))
                        .padding(.horizontal, 16)
                    Button(PitstopAPPStrings.Common.save) {
                        showPlateInput.dismiss()
                    }
                    .buttonStyle(Primary())
                    .disabled(plateNumber.isEmpty)
                }
            }
            .padding(.vertical, 16)
            .background(Rectangle()
                .cornerRadius(18)
                .foregroundColor(Palette.white)
            )
            .padding(.horizontal, 6)
        }
    }

    struct OdometerInputAlert: View {
        @Binding var odometer: Float
        @Binding var showOdometerInput: AlertConfig
        @FocusState private var focusedField: FocusFieldAlertOB?

        var body: some View {
            VStack(spacing: 16) {
                HStack {
                    Spacer()
                    Text(PitstopAPPStrings.Onb.writeOdometer)
                        .foregroundColor(Palette.black)
                        .font(Typography.headerM)
                        .padding(.leading, 40)
                    Spacer()
                    Button(action: {
                        showOdometerInput.dismiss()
                    }, label: {
                        ZStack {
                            Circle()
                                .frame(width: 24, height: 24)
                                .foregroundColor(Palette.greyLight)
                            Image(.ics)
                        }
                        .foregroundColor(Palette.black)
                        .padding(.trailing, 20)
                    })
                }
                VStack(spacing: 12) {
                    TextField(PitstopAPPStrings.Onb.odometerPlaceholder, value: $odometer, formatter: NumberFormatter())
                        .textFieldStyle(BoxTextFieldStyle(focusedField: $focusedField, field: .odometer))
                        .keyboardType(.decimalPad)
                        .padding(.horizontal, 16)
                    Button(PitstopAPPStrings.Common.save) {
                        showOdometerInput.dismiss()
                    }
                    .buttonStyle(Primary())
                    .disabled(odometer <= 0)
                }
            }
            .padding(.vertical, 16)
            .background(Rectangle()
                .cornerRadius(18)
                .foregroundColor(Palette.white)
            )
            .padding(.horizontal, 6)
        }
    }

    enum FocusFieldAlertOB: Hashable {
        case odometer
        case plate
    }
}

#Preview {
    OnbMoreInfoView(input: OnbVehicleInputData())
        .environmentObject(NavigationManager())
        .environmentObject(VehicleManager())
        .environment(AppState())
}
