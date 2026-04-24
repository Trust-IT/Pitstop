//
//  HeaderContentView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 12/05/22.
//

import SwiftUI

struct HeaderContent: View {
    @Binding var offset: CGFloat
    var maxHeight: CGFloat

    @Environment(VehicleManager.self) var vehicleManager: VehicleManager
    @Environment(AppState.self) var appState: AppState

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack(spacing: 13) {
                Button(action: {}, label: {
                    ZStack {
                        Rectangle()
                            .cornerRadius(16)
                            .foregroundColor(appState.currentTheme.colors.card)
                            .frame(width: UIScreen.main.bounds.width * 0.29, height: UIScreen.main.bounds.height * 0.09)
                        VStack(alignment: .center) {
                            Text(appState.currency.format(vehicleManager.totalFuelCost))
                                .foregroundColor(Palette.blackHeader)
                                .font(Typography.headerLM)
                            Text("All costs")
                                .foregroundColor(Palette.blackHeader)
                                .font(Typography.TextM)
                        }
                    }
                }).disabled(true)

                Button(action: {}, label: {
                    ZStack {
                        Rectangle()
                            .cornerRadius(16)
                            .foregroundColor(appState.currentTheme.colors.card)
                            .frame(width: UIScreen.main.bounds.width * 0.29, height: UIScreen.main.bounds.height * 0.09)
                        VStack(alignment: .center) {
                            Text(appState.measurementUnit.format(vehicleManager.currentVehicle.currentOdometer))
                                .foregroundColor(Palette.blackHeader)
                                .font(Typography.headerLM)
                            Text("Odometer")
                                .foregroundColor(Palette.blackHeader)
                                .font(Typography.TextM)
                        }
                    }
                }).disabled(true)

                if let efficiency = vehicleManager.fuelEfficiency {
                    Button(action: {}, label: {
                        ZStack {
                            Rectangle()
                                .cornerRadius(16)
                                .foregroundColor(appState.currentTheme.colors.card)
                                .frame(width: UIScreen.main.bounds.width * 0.29, height: UIScreen.main.bounds.height * 0.09)
                            VStack(alignment: .center) {
                                let formattedEfficiency = String(format: "%.1f", efficiency)
                                Text("\(formattedEfficiency) / 100")
                                    .foregroundColor(Palette.blackHeader)
                                    .font(Typography.headerLM)
                                Text(String(localized: "Efficiency") + " (\(appState.volumeUnit.symbol)/\(appState.measurementUnit.symbol))")
                                    .foregroundColor(Palette.blackHeader)
                                    .font(Typography.TextM)
                            }
                        }
                    }).disabled(true)
                }
            }
        }
        .padding()
        .padding(.bottom)
    }
}
