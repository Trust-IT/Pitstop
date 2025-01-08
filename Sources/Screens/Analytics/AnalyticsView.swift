//
//  AnalyticsView.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 08/01/25.
//

import Foundation
import SwiftUI

struct AnalyticsView: View {
    @State private var selectedTimeFrame: AnalyticsTimeFrame = .month
    @State private var selectedTab: AnalyticsTabs = .overview

    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    Spacer()
                    Text("You’re also provided with a table showing the exchanges that are supported by the market. No other exchanges besides those listed are possible. For example, you can exchange 100 random stones for 1 crocodile egg, 5 mysterious boxes, or 40 unfunny jokes. Exchanging random stones for superb capes is forbidden—what a pity! Note that exchanging different quantities is allowed only as long as the input item quantity is a multiple of that shown in the table.")
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Palette.greyBackground)
            .overlay(alignment: .bottom) {
                SegmentedPicker(currentTab: $selectedTab, onTap: {})
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
}

enum AnalyticsTimeFrame: String, CaseIterable, Identifiable {
    case month = "Per month"
    case year = "Yearly"

    var id: Self { self }
}

enum AnalyticsTabs: String, CaseIterable, Identifiable {
    case overview = "Overview"
    case fuel = "Fuel"
    case odometer = "Odometer"

    var id: Self { self }
}
