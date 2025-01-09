//
//  FuelAnalyticsView.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 09/01/25.
//

import SwiftUI

struct FuelAnalyticsView: View {
    var body: some View {
        VStack {
            HStack {
                Text("8.71 L/100 km")
                    .font(Typography.headerXL)
                    .foregroundStyle(Palette.black)
                Spacer()
                HStack {
                    Image("arrow")
                    Text("12 %")
                }
            }
            CustomList {
                fuelAnalyticsRow(category: "Test", amount: "$ 84")
                fuelAnalyticsRow(category: "Test", amount: "$ 84")
                fuelAnalyticsRow(category: "Test", amount: "$ 84")
                fuelAnalyticsRow(category: "Test", amount: "$ 84")
            }
            Spacer()
        }
        .background(Palette.greyBackground)
    }

    @ViewBuilder
    func fuelAnalyticsRow(category: String, amount: String) -> some View {
        HStack {
            Text(category)
                .font(Typography.headerM)
                .foregroundStyle(Palette.black)
            Spacer()
            Text(amount)
                .font(Typography.headerM)
                .foregroundStyle(Palette.greyHard)
        }
    }
}

#Preview {
    FuelAnalyticsView()
}
