//
//  OnboardingVehicleDetailsView.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 16/01/25.
//

import SwiftUI

struct OnboardingVehicleDetailsView: View {
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

    @Binding var plate: String
    @Binding var odometer: Int

    var body: some View {
        VStack {
            Spacer(minLength: 60)
            VStack(spacing: 12) {
                Text(PitstopStrings.Localizable.Onb.moreInfo)
                    .font(Typography.headerXL)
                    .foregroundColor(Palette.black)
                Text(PitstopStrings.Localizable.Onb.vehicleInfo)
                    .font(Typography.TextM)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Palette.black)
            }
            ScrollView(showsIndicators: false) {
                Button(action: {
                    showPlateInput.present()
                }, label: {
                    moreInfoCard(text: PitstopStrings.Localizable.Onb.plateNumber,
                                 bgColor: appState.currentTheme.colors.background,
                                 iconName: .star)
                })
                if !plate.isEmpty {
                    cardInput(value: plate)
                }
                Button(action: {
                    showOdometerInput.present()
                }, label: {
                    moreInfoCard(text: PitstopStrings.Localizable.Common.odometer,
                                 bgColor: appState.currentTheme.colors.background,
                                 iconName: .odometer)
                })
                if odometer != 0 {
                    cardInput(value: String(odometer))
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 56)
            Spacer()
        }
        .background(Palette.greyBackground)
        .alert(config: $showPlateInput) {
            PlateInputAlert(plateNumber: $plate, showPlateInput: $showPlateInput)
        }
        .alert(config: $showOdometerInput) {
            OdometerInputAlert(odometer: $odometer, showOdometerInput: $showOdometerInput)
        }
    }
}

// MARK: Additional Views

private extension OnboardingVehicleDetailsView {
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

private extension OnboardingVehicleDetailsView {
    struct PlateInputAlert: View {
        @Binding var plateNumber: String
        @Binding var showPlateInput: AlertConfig
        @FocusState private var focusedField: FocusFieldAlertOB?

        var body: some View {
            VStack(spacing: 16) {
                HStack {
                    Spacer()
                    Text(PitstopStrings.Localizable.Onb.writePlate)
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
                        .boxFieldStyle(focusedField: $focusedField, field: .plate)
                        .padding(.horizontal, 16)
                    Button(PitstopStrings.Localizable.Common.save) {
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
        @Binding var odometer: Int
        @Binding var showOdometerInput: AlertConfig
        @FocusState private var focusedField: FocusFieldAlertOB?

        var body: some View {
            VStack(spacing: 16) {
                HStack {
                    Spacer()
                    Text(PitstopStrings.Localizable.Onb.writeOdometer)
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
                    TextField(PitstopStrings.Localizable.Onb.odometerPlaceholder, value: $odometer, format: .number)
                        .boxFieldStyle(focusedField: $focusedField, field: .odometer)
                        .keyboardType(.numberPad)
                        .padding(.horizontal, 16)
                    Button(PitstopStrings.Localizable.Common.save) {
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
    @Previewable @State var plate = ""
    @Previewable @State var odometer = 0
    OnboardingVehicleDetailsView(plate: $plate, odometer: $odometer)
        .environment(AppState())
}
