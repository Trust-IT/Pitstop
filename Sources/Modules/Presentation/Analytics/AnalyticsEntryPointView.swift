//
//  AnalyticsEntryPointView.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 08/01/25.
//

import Foundation
import SwiftUI

struct AnalyticsEntryPointView: View {
    @Environment(VehicleManager.self) var vehicleManager: VehicleManager
    @EnvironmentObject private var navManager: NavigationManager
    @Environment(AppState.self) var appState: AppState
    @State private var selectedTab: AnalyticsTabs = .lastMonth

    var body: some View {
        NavigationStack(path: $navManager.routes) {
            VStack {
                ScrollView {
                    Spacer()
                    switch selectedTab {
                    case .yearly:
                        AnalyticsYearView()
                    case .lastMonth:
                        AnalyticsMonthlyView()
                    }
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Palette.greyBackground)
            .overlay(alignment: .bottom) {
                SegmentedPicker(currentTab: $selectedTab, style: .black)
                    .padding(10)
                    .background(.ultraThinMaterial)
            }
            .navigationTitle("Analytics")
            .navigationDestination(for: Route.self) { route in
                route
                    .environment(appState)
                    .environment(vehicleManager)
                    .toolbar(.hidden, for: .tabBar)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // TODO: Implement export
                    }, label: {
                        Image(systemName: "tray.and.arrow.down")
                    })
                    .buttonStyle(.glass)
                }
            }
        }
    }
}

#Preview {
    AnalyticsEntryPointView()
        .environment(VehicleManager())
        .environmentObject(NavigationManager())
        .environment(AppState())
        .environment(SceneDelegate())
}

enum AnalyticsTabs: String, CaseIterable, Identifiable {
    case yearly = "Yearly"
    case lastMonth = "Last 30 days"

    var id: Self { self }
}
