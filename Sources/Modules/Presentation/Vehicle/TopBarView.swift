//
//  TopBarView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 26/05/22.
//

import ChassisUI
import NavigatorUI
import PitstopData
import SwiftUI

struct TopBarView: View {
    @Environment(VehicleManager.self) var vehicleManager: VehicleManager
    @Environment(\.navigator) var navigator

    var offset: CGFloat
    let maxHeight: CGFloat
    var topEdge: CGFloat

    var body: some View {
        ZStack(alignment: .center) {
            // Expanded state — fades out as user scrolls down
            HStack(alignment: .center) {
                Menu {
                    Section(String(localized: "Select vehicle")) {
                        ForEach(vehicleManager.vehicles, id: \.uuid) { vehicle in
                            Button(vehicle.displayName) {
                                vehicleManager.setCurrentVehicle(vehicle)
                            }
                        }
                    }
                } label: {
                    HStack(alignment: .firstTextBaseline, spacing: 6) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(vehicleManager.currentVehicle.displayName)
                                .foregroundColor(Palette.blackHeader)
                                .font(Typography.headerL)
                            if let plate = vehicleManager.currentVehicle.plate {
                                Text(plate)
                                    .foregroundColor(Palette.blackHeader)
                                    .font(Typography.TextM)
                            }
                        }
                        Image(systemName: "chevron.down")
                            .foregroundColor(Palette.blackHeader)
                    }
                }
                Spacer()
                Button {
                    navigator.navigate(to: VehicleDestinations.reminderList)
                } label: {
                    HStack(spacing: 4) {
                        Text(PitstopStrings.Localizable.Reminder.title)
                            .font(Typography.ControlS)
                            .foregroundStyle(Palette.blackHeader)
                        Image(systemName: "bell")
                            .foregroundStyle(Palette.blackHeader)
                    }
                    .padding(.horizontal, 4)
                    .padding(.vertical, 2)
                }
                .buttonStyle(.glass)
            }
            .padding(.horizontal, 16)
            .opacity(fadeOutOpacity())
            .disabled(fadeOutOpacity() < 0.35)

            // Compressed state — fades in as user scrolls down
            HStack(alignment: .center) {
                Menu {
                    Section(String(localized: "Select vehicle")) {
                        ForEach(vehicleManager.vehicles, id: \.uuid) { vehicle in
                            Button(vehicle.displayName) {
                                vehicleManager.setCurrentVehicle(vehicle)
                            }
                        }
                    }
                } label: {
                    HStack(alignment: .firstTextBaseline, spacing: 5) {
                        VStack(alignment: .leading, spacing: 1) {
                            Text(vehicleManager.currentVehicle.displayName)
                                .foregroundColor(Palette.blackHeader)
                                .font(Typography.headerM)
                            if let plate = vehicleManager.currentVehicle.plate {
                                Text(plate)
                                    .foregroundColor(Palette.blackHeader)
                                    .font(Typography.ControlS)
                            }
                        }
                        Image(systemName: "chevron.down")
                            .foregroundColor(Palette.blackHeader)
                    }
                }
                Spacer()
                Button {
                    navigator.navigate(to: VehicleDestinations.reminderList)
                } label: {
                    Image(systemName: "bell")
                        .foregroundStyle(Palette.blackHeader)
                }
                .buttonStyle(.glass)
                .frame(width: 44, height: 44)
            }
            .padding(.horizontal, 16)
            .opacity(fadeInOpacity())
            .disabled(fadeInOpacity() < 0.35)
        }
        .frame(maxWidth: .infinity)
        // SHOULD BE COMMENTED FOR NOW
//        .background {
//            Rectangle()
//                .glassEffect()
//                .opacity(fadeInOpacity())
//        }
    }

    func fadeInOpacity() -> CGFloat {
        let progress = -(offset + 70) / (maxHeight - (60 + topEdge * 3.2))
        return max(0, min(1, progress))
    }

    func fadeOutOpacity() -> CGFloat {
        let progress = -offset / 70
        let opacity = 1 - progress
        return offset < 0 ? max(0, min(1, opacity)) : 1
    }
}
