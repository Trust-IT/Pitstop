//
//  SettingsView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 06/05/22.
//

import SwiftData
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var navManager: NavigationManager
    @Environment(AppState.self) var appState: AppState
    @EnvironmentObject var vehicleManager: VehicleManager
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
                                        color: Palette.greyBackground
                                    ))
                                    Spacer()
                                    Image(.arrowRight)
                                }
                            })
                        }

                        Button(action: {
                            navManager.push(.onboardingRegistration)
                            appState.setAddingNewVehicle(true)
                        }, label: {
                            HStack {
                                CategoryRow(input: .init(
                                    title: "Add vehicle",
                                    icon: .plus,
                                    color: Palette.greyBackground
                                ))
                                Spacer()
                                Image(.arrowRight)
                            }
                        })
                    }
                    .listRowInsets(EdgeInsets(top: 5, leading: 16, bottom: 5, trailing: 16))

                    Section(header: Text("Other")) {
                        Button(action: {
                            themePickerAlert.present()
                        }, label: {
                            HStack {
                                CategoryRow(input: .init(
                                    title: "Theme picker",
                                    icon: .service,
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
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Settings")
                        .foregroundColor(Palette.black)
                        .font(Typography.headerXL)
                }
            }
            .background(Palette.greyBackground)
            .alert(config: $themePickerAlert) {
                ThemePickerView(alert: $themePickerAlert)
                    .environment(appState)
            }
            .navigationDestination(for: Route.self) { route in
                route
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
            print("Failed to delete vehicle: \(error)")
        }
        vehicleManager.setCurrentVehicle(vehicles.first ?? .mock())
    }
}

#Preview {
    SettingsView()
        .environment(AppState())
        .environmentObject(NavigationManager())
        .environmentObject(VehicleManager())
}
