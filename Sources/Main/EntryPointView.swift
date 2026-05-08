//
//  EntryPointView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 06/05/22.
//

import ChassisUI
import NavigatorUI
import PitstopData
import SwiftUI

struct EntryPointView: View {
    @Environment(AppState.self) var appState: AppState
    @Environment(VehicleManager.self) var vehicleManager: VehicleManager
    @State private var selectedTab: TabBarItem = .vehicle
    @State private var isPresented = false
    @State private var sheetContentHeight = CGFloat(0)

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab(PitstopStrings.Localizable.Common.vehicle, image: ChassisUIAsset.carIcon.name, value: TabBarItem.vehicle) {
                VehicleView()
            }

            Tab(PitstopStrings.Localizable.Common.analytics, image: ChassisUIAsset.chartIcon.name, value: TabBarItem.analytics) {
                AnalyticsEntryPointView()
            }

            Tab(PitstopStrings.Localizable.Common.settings, image: ChassisUIAsset.settingsIcon.name, value: TabBarItem.settings) {
                SettingsView()
            }

            Tab(PitstopStrings.Localizable.Common.add, image: ChassisUIAsset.plusIcon.name, value: TabBarItem.add, role: .search) {
                Text("If you see this, then something is broken")
            }
        }
        .tabBarMinimizeBehavior(.onScrollDown)
        .environment(appState)
        .onChange(of: selectedTab) { previousTab, currentTab in
            if currentTab == .add {
                selectedTab = previousTab
                isPresented.toggle()
            }
        }
        .sheet(isPresented: $isPresented) {
            AddReportMenuView(isPresented: $isPresented)
                .environment(appState)
                .background(
                    GeometryReader { proxy in
                        Color.clear.task { sheetContentHeight = proxy.size.height }
                    }
                )
                .presentationDetents([.height(sheetContentHeight)])
                .presentationDragIndicator(.visible)
        }
        .presentationModifier(inherits: true) { destination in
            destination()
                .environment(appState)
                .environment(vehicleManager)
        }
        .tint(appState.currentTheme.accentColor)
        .onNavigationReceive { (_: ShowOnboardingWelcomeEvent, nav) in
            nav.navigate(to: OnboardingDestinations.welcome)
            return .auto
        }
        .onNavigationReceive { (_: ShowAddVehicleEvent, nav) in
            nav.navigate(to: OnboardingDestinations.addVehicle)
            return .auto
        }
    }
}

enum TabBarItem: String {
    case vehicle
    case analytics
    case settings
    case add
}

#Preview {
    @Previewable @State var vehicleManager = PreviewSupport.vehicleManager
    EntryPointView()
        .environment(vehicleManager)
        .environment(AppState())
}
