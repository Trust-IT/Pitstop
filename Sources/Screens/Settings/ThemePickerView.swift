//
//  ThemePickerView.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 04/01/25.
//

import SwiftData
import SwiftUI

struct ThemePickerView: View {
    @State private var sliderValue: Double = 0.0
    @State private var selectedColor: ThemeColors = .amethystDrive

    var body: some View {
        VStack {
            ZStack(alignment: .topLeading) {
                UnevenRoundedRectangle(topLeadingRadius: 20, topTrailingRadius: 20)
                    .fill(selectedColor.colors.background)
                    .frame(height: UIScreen.main.bounds.height * 0.25)
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("xxxxxxxxxx")
                                .font(Typography.headerXL)
                            Text("xxxxxxxx")
                                .font(Typography.headerM)
                        }
                        Spacer()
                        Circle()
                            .fill(selectedColor.colors.card).frame(width: 30, height: 30)
                    }
                    HStack {
                        Spacer()
                        ZStack {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(selectedColor.colors.card).frame(width: 90, height: 70)
                            Text("xxxxx")
                        }
                        Spacer()
                        ZStack {
                            RoundedRectangle(cornerRadius: 10, style: .circular)
                                .fill(selectedColor.colors.card)
                                .frame(width: 90, height: 70)
                            Text("xxxxx")
                        }
                        Spacer()
                        ZStack {
                            RoundedRectangle(cornerRadius: 10, style: .circular)
                                .fill(selectedColor.colors.card)
                                .frame(width: 90, height: 70)
                            Text("xxxxx")
                        }
                        Spacer()
                    }
                    .padding(.top, 40)
                }
                .padding(20)
                .redacted(reason: .placeholder)
            }
            Spacer()
            Text(selectedColor.rawValue)
                .font(Typography.headerL)
                .foregroundColor(Palette.black)
            Slider(
                value: $sliderValue,
                in: 0 ... 3,
                step: 1
            )
            .accentColor(Palette.black)
            .padding()
            .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height * 0.55)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(Palette.greyBackground)
        }
        .padding(20)
        .onChange(of: sliderValue) {
            selectedColor = currentColor()
        }
    }

    private func currentColor() -> ThemeColors {
        switch sliderValue {
        case 0:
            ThemeColors.amethystDrive
        case 1:
            ThemeColors.greenlight
        case 2:
            ThemeColors.goldenGear
        case 3:
            ThemeColors.aquaDrift
        default:
            ThemeColors.amethystDrive
        }
    }
}

#Preview {
    ThemePickerView()
        .background(Palette.black)
}

enum ThemeColors: String, CaseIterable {
    case amethystDrive = "Amethyst Drive"
    case greenlight = "Greenlight"
    case goldenGear = "Golden Gear"
    case aquaDrift = "Aqua Drift"

    var colors: (background: Color, card: Color) {
        switch self {
        case .amethystDrive:
            (Palette.colorViolet, Palette.colorMainViolet)
        case .greenlight:
            (Palette.colorGreen, Palette.colorMainGreen)
        case .goldenGear:
            (Palette.colorYellow, Palette.colorMainYellow)
        case .aquaDrift:
            (Palette.colorBlue, Palette.colorMainBlue)
        }
    }
}
