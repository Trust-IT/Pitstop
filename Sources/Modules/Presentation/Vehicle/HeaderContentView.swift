//
//  HeaderContentView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 12/05/22.
//

import ChassisUI
import PitstopData
import SwiftUI

struct HeaderContent: View {
    @Binding var offset: CGFloat
    var maxHeight: CGFloat

    @Environment(VehicleManager.self) var vehicleManager: VehicleManager
    @Environment(AppState.self) var appState: AppState

    private let cardHeight: CGFloat = 60

    var body: some View {
        HStack(spacing: 10) {
            Button {} label: {
                VStack(alignment: .center, spacing: 4) {
                    Text(appState.currency.format(vehicleManager.totalFuelCost))
                        .foregroundColor(Palette.blackHeader)
                        .font(Typography.headerLM)
                    Text("All costs")
                        .foregroundColor(Palette.blackHeader)
                        .font(Typography.TextM)
                }
                .frame(maxWidth: .infinity, minHeight: cardHeight)
            }
            .buttonStyle(.glass)

            Button {} label: {
                VStack(alignment: .center, spacing: 4) {
                    Text(appState.measurementUnit.format(vehicleManager.currentVehicle.currentOdometer))
                        .foregroundColor(Palette.blackHeader)
                        .font(Typography.headerLM)
                    Text("Odometer")
                        .foregroundColor(Palette.blackHeader)
                        .font(Typography.TextM)
                }
                .frame(maxWidth: .infinity, minHeight: cardHeight)
            }
            .buttonStyle(.glass)

            if let efficiency = vehicleManager.fuelEfficiency {
                Button {} label: {
                    VStack(alignment: .center, spacing: 4) {
                        Text(String(format: "%.1f / 100", efficiency))
                            .foregroundColor(Palette.blackHeader)
                            .font(Typography.headerLM)
                        Text(
                            String(localized: "Efficiency")
                                + " (\(appState.volumeUnit.symbol)/\(appState.measurementUnit.symbol))"
                        )
                        .foregroundColor(Palette.blackHeader)
                        .font(Typography.TextM)
                    }
                    .frame(maxWidth: .infinity, minHeight: cardHeight)
                }
                .buttonStyle(.glass)
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }
}
