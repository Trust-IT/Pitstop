//
//  EntryPointView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 06/05/22.
//

import SwiftUI

struct EntryPointView: View {
    @EnvironmentObject private var navManager: NavigationManager
    @Environment(AppState.self) var appState: AppState
    @State private var isPresented = false

    var body: some View {
        TabView(selection: $navManager.selectedTab) {
            Tab(PitstopAPPStrings.Common.vehicle, image: PitstopAPPAsset.Assets.carIcon.name, value: TabBarItem.vehicle) {
                VehicleView()
            }

            Tab(PitstopAPPStrings.Common.analytics, image: PitstopAPPAsset.Assets.chartIcon.name, value: TabBarItem.analytics) {
                AnalyticsView()
            }

            Tab(PitstopAPPStrings.Common.settings, image: PitstopAPPAsset.Assets.settingsIcon.name, value: TabBarItem.settings) {
                SettingsView()
            }

            Tab(PitstopAPPStrings.Common.add, image: PitstopAPPAsset.Assets.plusIcon.name, value: TabBarItem.add, role: .search) {
                Text("If you see this, then something is broken")
            }
        }
        .tabBarMinimizeBehavior(.onScrollDown)
        .environment(appState)
        .onChange(of: navManager.selectedTab) { previousTab, currentTab in
            if currentTab == .add {
                navManager.selectedTab = previousTab
                isPresented.toggle()
            }
        }
        .sheet(isPresented: $isPresented) {
            AddReportMenuView(appState: appState, isPresented: $isPresented)
                .environment(appState)
                .presentationDetents([.fraction(0.35)])
                .presentationDragIndicator(.visible)
        }
        .tint(appState.currentTheme.accentColor)
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
