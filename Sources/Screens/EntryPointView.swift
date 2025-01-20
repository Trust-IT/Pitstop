//
//  EntryPointView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 06/05/22.
//

import SwiftUI

struct EntryPointView: View {
    @EnvironmentObject private var navManager: NavigationManager
    @State var selectedTab: TabBarItem = .vehicle

    var body: some View {
        TabView(selection: $selectedTab) {
            VehicleView()
                .tabItem {
                    Label("Vehicle", image: .carIcon)
                }
                .tag(TabBarItem.vehicle)

            AnalyticsView()
                .tabItem {
                    Label("Analytics", image: .chartIcon)
                }
                .tag(TabBarItem.analytics)

            SettingsView()
                .tabItem {
                    Label("Settings", image: .settingsIcon)
                }
                .tag(TabBarItem.settings)
        }
        .onAppear {
            UITabBar.appearance().unselectedItemTintColor = Palette.greyEBEBEB.uiColor
            UITabBarItem.appearance().badgeColor = Palette.black.uiColor
            UITabBar.appearance().backgroundColor = Palette.white.uiColor
        }
        .tint(Palette.black)
    }
}

enum TabBarItem: String {
    case vehicle
    case analytics
    case settings
}

#Preview {
    EntryPointView()
        .environmentObject(NavigationManager())
}
