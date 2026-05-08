//
//  SettingsView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 06/05/22.
//

import ChassisUI
import NavigatorUI
import PitstopData
import SwiftUI

struct SettingsView: View {
    @Environment(AppState.self) var appState: AppState
    @Environment(VehicleManager.self) var vehicleManager: VehicleManager

    @State private var themePickerAlert: AlertConfig = .init(
        enableBackgroundBlur: true,
        disableOutsideTap: true,
        transitionType: .slide
    )

    var body: some View {
        ManagedNavigationStack(name: "Settings") { navigator in
            VStack {
                Text("")
                CustomList {
                    Section(header: Text("Vehicles")) {
                        ForEach(vehicleManager.vehicles, id: \.uuid) { vehicle in
                            Button(action: {
                                navigator.navigate(to: SettingsDestinations.editVehicle(input: vehicle))
                            }, label: {
                                HStack {
                                    CategoryRow(input: .init(
                                        title: vehicle.displayName,
                                        icon: ChassisUIAsset.carSettings,
                                        color: appState.currentTheme.colors.background
                                    ))
                                    Spacer()
                                    ChassisUIAsset.arrowRight.swiftUIImage
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
                                    icon: ChassisUIAsset.wrench,
                                    color: Palette.greyBackground
                                ))
                                Spacer()
                                ChassisUIAsset.arrowRight.swiftUIImage
                            }
                        })
                        Button(action: {
                            navigator.navigate(to: SettingsDestinations.aboutUs)
                        }, label: {
                            HStack {
                                CategoryRow(input: .init(
                                    title: "About us",
                                    icon: ChassisUIAsset.paperclip,
                                    color: Palette.greyBackground
                                ))
                                Spacer()
                                ChassisUIAsset.arrowRight.swiftUIImage
                            }
                        })
                        Button(action: {
                            navigator.navigate(to: SettingsDestinations.tos)
                        }, label: {
                            HStack {
                                CategoryRow(input: .init(
                                    title: "Terms of service",
                                    icon: ChassisUIAsset.paperclip,
                                    color: Palette.greyBackground
                                ))
                                Spacer()
                                ChassisUIAsset.arrowRight.swiftUIImage
                            }
                        })
                    }
                    .listRowInsets(EdgeInsets(top: 5, leading: 16, bottom: 5, trailing: 16))
                }
                .listStyle(.insetGrouped)
                Spacer()
            }
            .navigationTitle(PitstopStrings.Localizable.Common.settings)
            .background(Palette.greyBackground)
            .alert(config: $themePickerAlert) {
                ThemePickerView(alert: $themePickerAlert)
                    .environment(appState)
            }
            .navigationModifier { destination in
                destination()
                    .toolbar(.hidden, for: .tabBar)
                    .environment(appState)
                    .environment(vehicleManager)
            }
        }
    }
}

#Preview {
    SettingsView()
        .environment(AppState())
}
