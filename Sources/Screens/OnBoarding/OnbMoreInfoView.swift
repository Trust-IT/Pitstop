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
    @Environment(\.modelContext) private var modelContext

    @State private var showPlateInput: AlertConfig = .init(
        enableBackgroundBlur: false,
        disableOutsideTap: false,
        transitionType: .slide
    )

    @State private var showOdometerInput: AlertConfig = .init(
        enableBackgroundBlur: false,
        disableOutsideTap: false,
        transitionType: .slide
    )

    @State private var showSecondaryFuelSelection: AlertConfig = .init(
        enableBackgroundBlur: true,
        disableOutsideTap: false,
        transitionType: .slide
    )

    let input: OnbVehicleInputData
    @State private var secondaryFuelType: FuelType?
    @State private var odometer: String?
    @State private var plate: String?
    
    var body: some View {
        VStack {
            Spacer(minLength: 60)
            VStack(spacing: 12) {
                Text("Add more info")
                    .font(Typography.headerXL)
                    .foregroundColor(Palette.black)
                Text("Keep all of your vehicle info at hand")
                    .font(Typography.TextM)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Palette.black)
            }
            ScrollView(showsIndicators: false) {
                Button(action: {
                    showPlateInput.present()
                }, label: {
                    moreInfoCard(text: "Plate number",
                                 bgColor: Palette.colorOrange,
                                 iconName: .basedOn)
                })
                if let plate {
                    cardInput(value: plate)
                }
                Button(action: {
                    showOdometerInput.present()
                }, label: {
                    moreInfoCard(text: "Odometer",
                                 bgColor: Palette.colorBlue,
                                 iconName: .odometer)
                })
                if let odometer {
                    cardInput(value: odometer)
                }
                Button(action: {
                    showSecondaryFuelSelection.present()
                }, label: {
                    moreInfoCard(text: "Second fuel type",
                                 bgColor: Palette.colorYellow,
                                 iconName: .fuel)
                })
                if let secondaryFuelType {
                    cardInput(value: secondaryFuelType.rawValue)
                }
            }
            .padding(.top, 56)
            .padding(.horizontal, 16)
            .alert(config: $showPlateInput) {
                // TODO: Implement plate input
                Text("WIP")
            }
            .alert(config: $showOdometerInput) {
                // TODO: Implement Odometer input
                Text("WIP")
            }
            .alert(config: $showSecondaryFuelSelection) {
                ConfirmationDialog(
                    items: FuelType.allCases,
                    message: "Select a fuel type",
                    onTap: { value in
                        secondaryFuelType = value
                        showSecondaryFuelSelection.dismiss()
                    },
                    onCancel: {
                        showSecondaryFuelSelection.dismiss()
                    }
                )
            }

            Spacer()
        }
    }
}

private extension OnbMoreInfoView {
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
                        .foregroundColor(Color(rgb: 0x9A7EFF))
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
    
    func cardInput(value: String) -> some View {
        return ZStack {
            Rectangle()
                .foregroundColor(Palette.greyLight)
                .cornerRadius(12)
            
            HStack {
                Text(value)
                    .font(Typography.ControlS)
                    .foregroundColor(Palette.black)
                Spacer()
            }
            .padding(.horizontal,15)
        }
        .frame(height: 64)
    }
}

#Preview {
    OnbMoreInfoView(input: OnbVehicleInputData())
        .environmentObject(NavigationManager())
}
