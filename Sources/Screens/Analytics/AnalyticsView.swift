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
    @State private var selectedTimeFrame: AnalyticsTimeFrame = .month
    @State private var selectedTab: AnalyticsTabs = .overview

    var body: some View {
        NavigationStack(path: $navManager.routes) {
            VStack {
                ScrollView {
                    Spacer()
                    switch selectedTab {
                    case .overview:
                        Text("Overview")
                    case .fuel:
                        FuelAnalyticsView()
                    case .odometer:
                        Text("Odometer")
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
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Analytics")
                        .font(Typography.headerXL)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    TimeFrameSelector(selectedTimeFrame: $selectedTimeFrame)
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

private struct TimeFrameSelector: View {
    @Binding var selectedTimeFrame: AnalyticsTimeFrame

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Palette.white)
                .cornerRadius(37)
                .frame(width: 125, height: UIScreen.main.bounds.height * 0.04)
                .shadowGrey()
            Menu {
                Picker(selection: $selectedTimeFrame, label: Text("")) {
                    ForEach(AnalyticsTimeFrame.allCases) { time in
                        Text(time.rawValue.capitalized).tag(time)
                    }
                }
            } label: {
                HStack {
                    Text(selectedTimeFrame.rawValue.capitalized)
                        .foregroundColor(Palette.black)
                        .font(Typography.ControlS)
                    Image("arrowDown")
                        .foregroundColor(Palette.black)
                }
            }
            .padding()
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

enum AnalyticsTimeFrame: String, CaseIterable, Identifiable {
    case month = "Last 30 days"
    case year = "Yearly"

    var id: Self { self }
}

enum AnalyticsTabs: String, CaseIterable, Identifiable {
    case overview = "Overview"
    case fuel = "Fuel"
    case odometer = "Odometer"

    var id: Self { self }
}
