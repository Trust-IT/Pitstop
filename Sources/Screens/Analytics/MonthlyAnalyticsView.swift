//
//  MonthlyAnalyticsView.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 09/01/25.
//

import Charts
import SwiftUI

struct MonthlyAnalyticsView: View {
    @EnvironmentObject var vehicleManager: VehicleManager
    @Environment(AppState.self) var appState: AppState
    @State private var selectedValue: String?
    @State private var animatedData: [(month: String, value: Float)] = []
    @State private var monthlyData: MonthlyFuelData = .init()
    @State private var efficiency: String = "0"

    var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 26) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(efficiency + " L / 100 km")
                        .font(Typography.headerL)
                        .foregroundStyle(Palette.black)
                    Text("Efficiency")
                        .font(Typography.headerS)
                        .foregroundStyle(Palette.greyMiddle)
                }
                Chart(animatedData, id: \.month) { item in
                    LineMark(
                        x: .value("Day", item.month),
                        y: .value("Value", item.value)
                    )
                    .foregroundStyle(.green)
                    .lineStyle(StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                    .interpolationMethod(.cardinal)

                    AreaMark(
                        x: .value("Day", item.month),
                        y: .value("Value", item.value)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Palette.chartGreen.opacity(0.3), Palette.chartGreen.opacity(0)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    if let selectedX = selectedValue, selectedX == item.month {
                        RuleMark(
                            x: .value("X", item.month)
                        )
                        .foregroundStyle(Palette.black.opacity(0.5))
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                        PointMark(
                            x: .value("X", item.month),
                            y: .value("Y", item.value)
                        )
                        .foregroundStyle(Palette.black)
                        .symbolSize(150)
                        .annotation(position: .top) {
                            Text("\(Int(item.value))")
                                .font(Typography.headerMS)
                                .foregroundColor(Palette.black)
                        }
                    }
                }
                .chartXSelection(value: $selectedValue)
                .chartXAxis {
                    AxisMarks(values: .automatic) { value in
                        if let month = value.as(String.self) {
                            AxisValueLabel(month)
                        }
                    }
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
        .background(Palette.greyBackground)
        .onAppear {
            animateChart()
        }
    }

    private func animateChart() {
        let graphData = vehicleManager.calculateFuelEfficencyData(expenses: vehicleManager.currentVehicle.fuelExpenses)
//        for (index, value) in graphData.enumerated() {
//            withAnimation(.interactiveSpring(duration: 0.3).delay(Double(index) * 0.1)) {
//                animatedData.append((month: value.0, value: value.1))
//            }
//        }
        animatedData = graphData
        let efficency = vehicleManager.calculateTotalFuelEfficency(efficencies: graphData.map(\.1))
        efficiency = efficency.rounded().toString()
        monthlyData = vehicleManager.getMonthlyFuelData()
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
    MonthlyAnalyticsView()
        .environmentObject(VehicleManager())
        .environmentObject(NavigationManager())
        .environment(AppState())
        .environment(SceneDelegate())
}
