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

    var body: some View {
        NavigationView {
            VStack {
                Text("Lorem")
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

            .background(Palette.greyBackground)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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

enum AnalyticsTimeFrame: String, CaseIterable, Identifiable {
    case month = "Per month"
    case year = "Yearly"

    var id: Self { self }
}
