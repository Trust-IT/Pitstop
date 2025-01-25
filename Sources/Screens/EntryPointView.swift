//
//  EntryPointView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 06/05/22.
//

import SwiftUI

struct EntryPointView: View {
    @EnvironmentObject private var navManager: NavigationManager
    @State private var isPresented = false

    var body: some View {
        TabView(selection: $navManager.selectedTab) {
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

            Text("If you see this, then something is broken")
                .tabItem {
                    Label("Add", image: .plusIcon)
                }
                .tag(TabBarItem.add)
        }
        .onChange(of: navManager.selectedTab) { previousTab, currentTab in
            if currentTab == .add {
                navManager.selectedTab = previousTab
                isPresented.toggle()
            }
        }
        .sheet(isPresented: $isPresented) {
            AddReportMenuView(isPresented: $isPresented)
                .presentationDetents([.fraction(0.25)])
                .presentationDragIndicator(.visible)
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
    case add
}

#Preview {
    EntryPointView()
        .environmentObject(NavigationManager())
        .environmentObject(VehicleManager())
        .environment(AppState())
        .environment(SceneDelegate())
}
