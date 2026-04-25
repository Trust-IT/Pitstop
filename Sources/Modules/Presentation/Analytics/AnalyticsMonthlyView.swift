//
//  AnalyticsMonthlyView.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 09/01/25.
//

import Charts
import SwiftUI

enum MonthlyMetric: String, CaseIterable, Identifiable {
    case efficiency = "Efficiency"
    case costPerKm = "Cost/km"

    var id: Self { self }

    func trendIcon(for trend: ChartTrend) -> String {
        switch (self, trend) {
        case (_, .neutral): "minus"
        case (.efficiency, .improving): "arrow.up"
        case (.efficiency, .worsening): "arrow.down"
        case (.costPerKm, .improving): "arrow.down"
        case (.costPerKm, .worsening): "arrow.up"
        }
    }
}

enum ChartTrend {
    case improving, worsening, neutral

    var icon: String {
        switch self {
        case .improving: "arrow.up"
        case .worsening: "arrow.down"
        case .neutral: "minus"
        }
    }

    var color: Color {
        switch self {
        case .improving: .green
        case .worsening: .red
        case .neutral: Palette.greyMiddle
        }
    }
}

struct AnalyticsMonthlyView: View {
    @Environment(VehicleManager.self) var vehicleManager: VehicleManager
    @Environment(AppState.self) var appState: AppState
    @Environment(\.modelContext) private var modelContext

    @State private var selectedValue: String?
    @State private var selectedMetric: MonthlyMetric = .efficiency
    @State private var efficiencyData: [(month: String, value: Float)] = []
    @State private var costPerKmData: [(month: String, value: Float)] = []
    @State private var monthlyData: MonthlyFuelData = .init()
    @State private var avgEfficiency: Float = 0
    @State private var avgCostPerKm: Float = 0

    private var chartData: [(month: String, value: Float)] {
        selectedMetric == .efficiency ? efficiencyData : costPerKmData
    }

    private var headerValue: String {
        switch selectedMetric {
        case .efficiency:
            avgEfficiency.rounded().toString() + " L / 100 km"
        case .costPerKm:
            appState.currency.format(avgCostPerKm) + " / km"
        }
    }

    private var trend: ChartTrend {
        let data = chartData
        guard data.count >= 3 else { return .neutral }
        let first = data.prefix(2).map(\.value).reduce(0, +) / 2
        let last = data.suffix(2).map(\.value).reduce(0, +) / 2
        if last < first * 0.97 { return .improving }
        if last > first * 1.03 { return .worsening }
        return .neutral
    }

    var body: some View {
        Group {
            if chartData.isEmpty {
                AnalyticsEmptyView(
                    title: "No data yet",
                    subtitle: "Add your first fuel expense to see analytics"
                )
            } else {
                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(alignment: .firstTextBaseline, spacing: 8) {
                            Text(headerValue)
                                .font(Typography.headerL)
                                .foregroundStyle(Palette.black)
                                .contentTransition(.numericText())
                                .animation(.easeInOut, value: selectedMetric)
                            Image(systemName: selectedMetric.trendIcon(for: trend))
                                .font(Typography.headerM)
                                .foregroundStyle(trend.color)
                        }
                        Text(selectedMetric.rawValue)
                            .font(Typography.headerS)
                            .foregroundStyle(Palette.greyMiddle)

                        SegmentedPicker(currentTab: $selectedMetric) {
                            selectedValue = nil
                        }
                        .padding(4)
                        .background(Palette.greyBackground)
                        .clipShape(Capsule())

                        Chart(chartData, id: \.month) { item in
                            LineMark(
                                x: .value("Day", item.month),
                                y: .value("Value", item.value)
                            )
                            .foregroundStyle(selectedMetric == .efficiency ? Palette.greenAccent : Palette.blueAccent)
                            .lineStyle(StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                            .interpolationMethod(.cardinal)

                            AreaMark(
                                x: .value("Day", item.month),
                                y: .value("Value", item.value)
                            )
                            .interpolationMethod(.cardinal)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: selectedMetric == .efficiency
                                        ? [Palette.chartGreen.opacity(0.4), Palette.chartGreen.opacity(0)]
                                        : [Palette.blueLine.opacity(0.4), Palette.blueLine.opacity(0)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )

                            if selectedMetric == .efficiency, let benchmark = vehicleManager.fuelEfficiency {
                                RuleMark(y: .value("All-time avg", benchmark))
                                    .foregroundStyle(Palette.greyMiddle.opacity(0.7))
                                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                                    .annotation(position: .top, alignment: .trailing) {
                                        Text("all-time avg")
                                            .font(Typography.ControlS)
                                            .foregroundStyle(Palette.greyMiddle)
                                    }
                            }

                            if let selectedX = selectedValue, selectedX == item.month {
                                RuleMark(x: .value("X", item.month))
                                    .foregroundStyle(Palette.black.opacity(0.5))
                                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                                PointMark(
                                    x: .value("X", item.month),
                                    y: .value("Y", item.value)
                                )
                                .foregroundStyle(Palette.black)
                                .symbolSize(150)
                                .annotation(position: .top) {
                                    Text(annotationText(for: item.value))
                                        .font(Typography.headerMS)
                                        .foregroundColor(Palette.black)
                                }
                            }
                        }
                        .chartXSelection(value: $selectedValue)
                        .chartXAxis {
                            AxisMarks(values: .automatic) { value in
                                if let label = value.as(String.self) {
                                    AxisValueLabel(label)
                                }
                            }
                        }
                        .chartYAxis {
                            AxisMarks(position: .leading, values: .automatic)
                        }
                        .animation(.easeInOut, value: selectedMetric)
                        .frame(height: 280)
                    }
                    .padding(16)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .background(RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Palette.white))
                    .padding(.horizontal, 16)

                    VStack(spacing: 16) {
                        fuelAnalyticsRow(category: "Total cost", amount: appState.currency.format(monthlyData.totalCost))
                        Divider()
                            .overlay(Palette.greyLight)
                        fuelAnalyticsRow(category: "Average liter price", amount: appState.currency.format(monthlyData.averageCost))
                        Divider()
                            .overlay(Palette.greyLight)
                        fuelAnalyticsRow(category: "Refuels amount", amount: monthlyData.refuelsAmount.description)
                        Divider()
                            .overlay(Palette.greyLight)
                        fuelAnalyticsRow(category: "Days from last refuel", amount: monthlyData.daysFromLastRefuel.description)
                    }
                    .padding(16)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .background(RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Palette.white))
                    .padding(.horizontal, 16)

                    Spacer()
                }
                .background(Palette.greyBackground)
            }
        }
        #if DEBUG
        .safeAreaInset(edge: .bottom) {
                HStack(spacing: 16) {
                    Button("Insert test data") { insertTestExpenses() }
                    Button("Clear expenses") { clearAllExpenses() }
                        .foregroundStyle(.red)
                }
                .font(Typography.ControlS)
                .padding(.vertical, 8)
                .background(.ultraThinMaterial)
            }
        #endif
            .onAppear { loadData() }
    }

    private func annotationText(for value: Float) -> String {
        switch selectedMetric {
        case .efficiency: "\(Int(value)) L/100km"
        case .costPerKm: appState.currency.format(value) + "/km"
        }
    }

    private func loadData() {
        let expenses = vehicleManager.fetchLast30Days(modelContext: modelContext)
        efficiencyData = vehicleManager.calculateFuelEfficencyData(expenses: expenses)
        costPerKmData = vehicleManager.calculateCostPerKmData(expenses: expenses)
        avgEfficiency = vehicleManager.calculateTotalFuelEfficency(efficencies: efficiencyData.map(\.1))
        avgCostPerKm = costPerKmData.map(\.value).reduce(0, +) / Float(max(costPerKmData.count, 1))
        monthlyData = vehicleManager.getMonthlyFuelData(expenses: expenses)
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

    #if DEBUG
        private func insertTestExpenses() {
            let vehicle = vehicleManager.currentVehicle
            let calendar = Calendar.current
            let now = Date.now
            let base = vehicle.currentOdometer

            // odometerOffset is cumulative km from year-start (always positive, monotonically increasing)
            // swiftlint:disable:next large_tuple
            let seedData: [(daysAgo: Int, odometerOffset: Int, liters: Float, total: Decimal)] = [
                // January
                (113, 0, 45.0, 72.90),
                (105, 450, 40.5, 65.61),
                // February
                (90, 1100, 43.0, 69.66),
                (82, 1550, 38.0, 61.56),
                (75, 2000, 41.5, 67.23),
                // March
                (60, 2700, 44.0, 71.28),
                (52, 3150, 39.5, 63.99),
                (44, 3650, 42.5, 68.85),
                // April (last 30 days)
                (28, 6170, 42.0, 68.04),
                (23, 6590, 38.5, 62.28),
                (18, 6960, 44.1, 71.42),
                (13, 7400, 39.8, 64.48),
                (8, 7790, 41.5, 67.23),
                (3, 8200, 40.0, 64.80),
            ]

            let totalTestKm = seedData.map(\.odometerOffset).max() ?? 0
            let yearStart = max(vehicle.initialOdometer, base - totalTestKm)

            for seed in seedData {
                guard let date = calendar.date(byAdding: .day, value: -seed.daysAgo, to: now) else { continue }
                let expense = FuelExpense(
                    totalCost: seed.total,
                    quantity: seed.liters,
                    odometer: yearStart + seed.odometerOffset,
                    fuelType: vehicle.mainFuelType,
                    date: date,
                    vehicle: vehicle
                )
                expense.insert(context: modelContext)
            }

            vehicleManager.refreshStats(modelContext: modelContext)
            loadData()
        }

        private func clearAllExpenses() {
            let expenses = vehicleManager.sortedExpenses
            expenses.forEach { $0.delete(context: modelContext) }
            try? modelContext.save()
            vehicleManager.refreshStats(modelContext: modelContext)
            loadData()
        }
    #endif
}

#Preview {
    AnalyticsMonthlyView()
        .environment(VehicleManager())
        .environmentObject(NavigationManager())
        .environment(AppState())
        .environment(SceneDelegate())
}
