//
//  TopBarView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 26/05/22.
//

import SwiftData
import SwiftUI

struct TopBarView: View {
    @Environment(VehicleManager.self) var vehicleManager: VehicleManager
    @EnvironmentObject var navManager: NavigationManager
    @Environment(\.modelContext) private var modelContext

    var offset: CGFloat
    let maxHeight: CGFloat
    var topEdge: CGFloat

    @Query var vehicles: [Vehicle]

    var body: some View {
        ZStack(alignment: .center) {
            // Expanded state — fades out as user scrolls down
            HStack(alignment: .center) {
                Menu {
                    Section(String(localized: "Select vehicle")) {
                        ForEach(vehicles, id: \.uuid) { vehicle in
                            Button(vehicle.displayName) {
                                vehicleManager.setCurrentVehicle(vehicle, modelContext: modelContext)
                            }
                        }
                    }
                } label: {
                    HStack(spacing: 6) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(vehicleManager.currentVehicle.brand)
                                .foregroundColor(Palette.blackHeader)
                                .font(Typography.headerXL)
                            Text(vehicleManager.currentVehicle.model)
                                .foregroundColor(Palette.blackHeader)
                                .font(Typography.TextM)
                                .opacity(0.6)
                        }
                        Image(.arrowLeft)
                            .resizable()
                            .foregroundColor(Palette.blackHeader)
                            .frame(width: 10, height: 14)
                            .rotationEffect(.degrees(270))
                    }
                }
                Spacer()
                Button {
                    navManager.push(.reminderList)
                } label: {
                    HStack(spacing: 4) {
                        Text(PitstopStrings.Localizable.Reminder.title)
                            .font(Typography.ControlS)
                        Image(systemName: "bell")
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
                        ForEach(vehicles, id: \.uuid) { vehicle in
                            Button(vehicle.displayName) {
                                vehicleManager.setCurrentVehicle(vehicle, modelContext: modelContext)
                            }
                        }
                    }
                } label: {
                    HStack(spacing: 5) {
                        VStack(alignment: .leading, spacing: 1) {
                            Text(vehicleManager.currentVehicle.brand)
                                .foregroundColor(Palette.blackHeader)
                                .font(Typography.headerM)
                            Text(vehicleManager.currentVehicle.model)
                                .foregroundColor(Palette.blackHeader)
                                .font(Typography.ControlS)
                                .opacity(0.55)
                        }
                        Image(.arrowLeft)
                            .resizable()
                            .foregroundColor(Palette.blackHeader)
                            .frame(width: 8, height: 11)
                            .rotationEffect(.degrees(270))
                    }
                }
                Spacer()
                Button {
                    navManager.push(.reminderList)
                } label: {
                    Image(systemName: "bell")
                        .font(.system(size: 15, weight: .medium))
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
