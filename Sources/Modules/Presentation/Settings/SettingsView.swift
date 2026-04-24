//
//  SettingsView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 06/05/22.
//

import OSLog
import SwiftData
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var navManager: NavigationManager
    @Environment(AppState.self) var appState: AppState
    @Environment(VehicleManager.self) var vehicleManager: VehicleManager
    @Environment(\.modelContext) private var modelContext

    @Query
    var vehicles: [Vehicle]

    @State private var themePickerAlert: AlertConfig = .init(
        enableBackgroundBlur: true,
        disableOutsideTap: true,
        transitionType: .slide
    )

    var body: some View {
        NavigationStack(path: $navManager.routes) {
            VStack {
                Text("")
                CustomList {
                    Section(header: Text("Vehicles")) {
                        ForEach(vehicles, id: \.uuid) { vehicle in
                            Button(action: {
                                navManager.push(.editVehicle(input: vehicle))
                            }, label: {
                                HStack {
                                    CategoryRow(input: .init(
                                        title: vehicle.name,
                                        icon: .carSettings,
                                        color: appState.currentTheme.colors.background
                                    ))
                                    Spacer()
                                    Image(.arrowRight)
                                }
                            })
                        }
                    }
                    .listRowInsets(EdgeInsets(top: 5, leading: 16, bottom: 5, trailing: 16))

                    Section(header: Text("Other")) {
                        Button(action: {
                            themePickerAlert.present()
                        }, label: {
                            HStack {
                                CategoryRow(input: .init(
                                    title: "Theme picker",
                                    icon: .wrench,
                                    color: Palette.greyBackground
                                ))
                                Spacer()
                                Image(.arrowRight)
                            }
                        })
                        Button(action: {
                            navManager.push(.aboutUs)
                        }, label: {
                            HStack {
                                CategoryRow(input: .init(
                                    title: "About us",
                                    icon: .paperclip,
                                    color: Palette.greyBackground
                                ))
                                Spacer()
                                Image(.arrowRight)
                            }
                        })
                        Button(action: {
                            navManager.push(.tos)
                        }, label: {
                            HStack {
                                CategoryRow(input: .init(
                                    title: "Terms of service",
                                    icon: .paperclip,
                                    color: Palette.greyBackground
                                ))
                                Spacer()
                                Image(.arrowRight)
                            }
                        })
                    }
                    .listRowInsets(EdgeInsets(top: 5, leading: 16, bottom: 5, trailing: 16))
                }
                .listStyle(.insetGrouped)
                Spacer()
            }
            .navigationTitle(PitstopAPPStrings.Common.settings)
            .background(Palette.greyBackground)
            .alert(config: $themePickerAlert) {
                ThemePickerView(alert: $themePickerAlert)
                    .environment(appState)
            }
            .navigationDestination(for: Route.self) { route in
                route
                    .environment(appState)
                    .environment(vehicleManager)
                    .toolbar(.hidden, for: .tabBar)
            }
        }
    }
}

private extension SettingsView {
    func deleteVehicle(at offsets: IndexSet) {
        for index in offsets {
            let vehicleToDelete = vehicles[index]
            modelContext.delete(vehicleToDelete)
        }

        do {
            try modelContext.save()
        } catch {
            Logger.persistence.error("Failed to delete vehicle: \(error)")
        }
        vehicleManager.setCurrentVehicle(vehicles.first ?? .mock(), modelContext: modelContext)
    }
}

#Preview {
    SettingsView()
        .environment(AppState())
        .environmentObject(NavigationManager())
        .environment(VehicleManager())
}
