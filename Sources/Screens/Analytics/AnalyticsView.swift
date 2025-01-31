//
//  AnalyticsView.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 08/01/25.
//

import Foundation
import SwiftUI

struct AnalyticsView: View {
    @EnvironmentObject var vehicleManager: VehicleManager
    @EnvironmentObject private var navManager: NavigationManager
    @State private var selectedTab: AnalyticsTabs = .lastMonth

    var body: some View {
        NavigationStack(path: $navManager.routes) {
            VStack {
                ScrollView {
                    Spacer()
                    switch selectedTab {
                    case .yearly:
                        YearAnalyticsView()
                    case .lastMonth:
                        MonthlyAnalyticsView()
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
            .navigationDestination(for: Route.self) { route in
                route
                    .toolbar(.hidden, for: .tabBar)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Analytics")
                        .font(Typography.headerXL)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}, label: {
                        ZStack {
                            Circle()
                                .fill(Palette.white)
                                .frame(width: 32, height: 32)
                                .shadowGrey()
                            Image(.download)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        }
                    })
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

#Preview {
    AnalyticsView()
        .environmentObject(VehicleManager())
        .environmentObject(NavigationManager())
        .environment(AppState())
        .environment(SceneDelegate())
}

enum AnalyticsTabs: String, CaseIterable, Identifiable {
    case yearly = "Yearly"
    case lastMonth = "Last 30 days"

    var id: Self { self }
}
