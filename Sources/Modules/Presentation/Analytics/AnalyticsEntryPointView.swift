//
//  AnalyticsEntryPointView.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 08/01/25.
//

import ChassisUI
import Foundation
import NavigatorUI
import PitstopData
import SwiftUI

struct AnalyticsEntryPointView: View {
    @Environment(VehicleManager.self) var vehicleManager: VehicleManager
    @Environment(AppState.self) var appState: AppState
    @State private var selectedTab: AnalyticsTabs = .lastMonth

    var body: some View {
        ManagedNavigationStack(name: "Analytics") { _ in
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
                    .glassEffect()
            }
            .navigationTitle("Analytics")
            .navigationModifier { destination in
                destination()
                    .toolbar(.hidden, for: .tabBar)
                    .environment(appState)
                    .environment(vehicleManager)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // TODO: Implement export
                    }, label: {
                        Image(systemName: "tray.and.arrow.down")
                            .foregroundStyle(Palette.black)
                    })
                    .buttonStyle(.glass)
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var vehicleManager = PreviewSupport.vehicleManager
    AnalyticsEntryPointView()
        .environment(vehicleManager)
        .environment(AppState())
}

enum AnalyticsTabs: String, CaseIterable, Identifiable {
    case yearly = "Yearly"
    case lastMonth = "Last 30 days"

    var id: Self { self }
}
