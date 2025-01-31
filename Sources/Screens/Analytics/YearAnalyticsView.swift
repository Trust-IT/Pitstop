//
//  YearAnalyticsView.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 27/01/25.
//

import Charts
import SwiftUI

struct YearAnalyticsView: View {
    @Environment(AppState.self) var appState: AppState

    @State private var yearData: [(month: String, value: Float)] = [
        ("Jan", 10), ("Feb", 15), ("Mar", 8), ("Apr", 20), ("May", 25),
        ("Jun", 30), ("Jul", 12), ("Aug", 18), ("Sep", 22), ("Oct", 28),
        ("Nov", 35), ("Dec", 0)
    ]
    @State private var monthlyData: MonthlyFuelData = .init()

    @State private var selectedMonth: String?
    @State private var showWip: Bool = false

    var body: some View {
        if showWip {
            VStack {
                VStack(alignment: .leading, spacing: 26) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("100" + " L / 100 km")
                            .font(Typography.headerL)
                            .foregroundStyle(Palette.black)
                        Text("Efficiency")
                            .font(Typography.headerS)
                            .foregroundStyle(Palette.greyMiddle)
                    }
                    Chart(yearData, id: \.month) { data in
                        BarMark(
                            x: .value("Month", data.month),
                            y: .value("Efficiency", data.value)
                        )
                        .foregroundStyle(selectedMonth == data.month ? Palette.blueLine : Palette.greyInput)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .chartXSelection(value: $selectedMonth)
                    .chartXAxis {
                        AxisMarks(values: yearData.map(\.month), stroke: StrokeStyle(lineWidth: 0))
                    }
                    .chartYAxis {
                        AxisMarks(position: .leading, values: .automatic)
                    }
                    .frame(height: 300)
                }
                .padding(16)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .background(RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Palette.white))
                .padding(.horizontal, 16)

                VStack(spacing: 16) {
                    fuelAnalyticsRow(category: "Total cost", amount: monthlyData.totalCost.description + appState.currency)
                    Divider()
                        .overlay(Palette.greyLight)
                    fuelAnalyticsRow(category: "Average liter price", amount: monthlyData.averageCost.description + appState.currency)
                    Divider()
                        .overlay(Palette.greyLight)
                    fuelAnalyticsRow(category: "Refuels amount", amount: monthlyData.refuelsAmount.description)
                    Divider()
                        .overlay(Palette.greyLight)
                    fuelAnalyticsRow(category: "Days from last refuel", amount: monthlyData.daysFromLastRefuel.description)
                }

                .padding(16)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Palette.white)
                )
                .padding(.horizontal, 16)
                Spacer()
            }
            .onChange(of: selectedMonth) { oldValue, newValue in
                if newValue == nil {
                    selectedMonth = oldValue
                }
            }
            .background(Palette.greyBackground)
        } else {
            VStack(spacing: 15) {
                Spacer()
                Text("⚠️ WARNING ⚠️")
                    .foregroundStyle(Palette.black)
                    .font(Typography.headerXL)
                Image(.page4)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300)
                Text("This section is under construction")
                    .foregroundStyle(Palette.black)
                    .font(Typography.headerM)
                Text("If you are a construction enjoyer, you can check the progress by pressing the button.\n Estimated finish time: somewhere in the future")
                    .foregroundStyle(Palette.black)
                    .multilineTextAlignment(.center)
                    .font(Typography.TextM)
                Spacer()
                Button("Show progress") {
                    showWip.toggle()
                }
                .buttonStyle(Secondary())
            }
            .background(Palette.greyBackground)
            .padding(.horizontal, 16)
        }
    }

    @ViewBuilder
    func fuelAnalyticsRow(category: String, amount: String) -> some View {
        HStack {
            Text(category)
                .font(Typography.headerM)
                .foregroundStyle(Palette.black)
            Spacer()
            Text(amount)
                .font(Typography.headerM)
                .foregroundStyle(Palette.greyHard)
        }
    }
}

#Preview {
    YearAnalyticsView()
        .environmentObject(VehicleManager())
        .environmentObject(NavigationManager())
        .environment(AppState())
        .environment(SceneDelegate())
}
