//
//  AnalyticsYearView.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 27/01/25.
//

import Charts
import SwiftUI

enum YearlyMetric: String, CaseIterable, Identifiable {
    case cost = "Cost"
    case liters = "Liters"
    case avgPrice = "Avg price"
    case refuels = "Refuels"

    var id: Self { self }
}

struct AnalyticsYearView: View {
    @Environment(AppState.self) var appState: AppState
    @Environment(VehicleManager.self) var vehicleManager: VehicleManager
    @Environment(\.modelContext) private var modelContext

    @State private var monthlyDataByMonth: [String: MonthlyFuelData] = [:]
    @State private var fullYearData: MonthlyFuelData = .init()
    @State private var selectedMonth: String?
    @State private var selectedMetric: YearlyMetric = .cost

    private var chartData: [(month: String, value: Float)] {
        Calendar.current.shortMonthSymbols.map { month in
            let data = monthlyDataByMonth[month]
            let value: Float = switch selectedMetric {
            case .cost: data?.totalCost ?? 0
            case .liters: data?.totalLiters ?? 0
            case .avgPrice: data?.averageCost ?? 0
            case .refuels: Float(data?.refuelsAmount ?? 0)
            }
            return (month: month, value: value)
        }
    }

    private var displayedData: MonthlyFuelData {
        selectedMonth.flatMap { monthlyDataByMonth[$0] } ?? fullYearData
    }

    private var headerValue: String {
        switch selectedMetric {
        case .cost: appState.currency.format(displayedData.totalCost)
        case .liters: String(format: "%.1f L", displayedData.totalLiters)
        case .avgPrice: appState.currency.format(displayedData.averageCost)
        case .refuels: "\(displayedData.refuelsAmount)"
        }
    }

    private var hasData: Bool { monthlyDataByMonth.values.contains { $0.totalCost > 0 } }

    var body: some View {
        Group {
            if !hasData {
                AnalyticsEmptyView(
                    title: "No data this year",
                    subtitle: "Add fuel expenses to track your yearly spending"
                )
            } else {
                yearContent
            }
        }
        .onAppear { loadData() }
    }

    @ViewBuilder
    private var yearContent: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(headerValue)
                        .font(Typography.headerL)
                        .foregroundStyle(Palette.black)
                        .contentTransition(.numericText())
                        .animation(.easeInOut, value: selectedMetric)
                    Text(selectedMonth ?? String(Calendar.current.component(.year, from: .now)))
                        .font(Typography.headerS)
                        .foregroundStyle(Palette.greyMiddle)
                }

                SegmentedPicker(currentTab: $selectedMetric)
                    .padding(4)
                    .background(Palette.greyBackground)
                    .clipShape(Capsule())

                Chart(chartData, id: \.month) { data in
                    BarMark(
                        x: .value("Month", data.month),
                        y: .value(selectedMetric.rawValue, data.value)
                    )
                    .foregroundStyle(selectedMonth == data.month ? appState.currentTheme.accentColor : Palette.greyInput)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .annotation(position: .top, spacing: 4) {
                        if selectedMonth == data.month, data.value > 0 {
                            Text(annotationText(for: data.value))
                                .font(Typography.ControlS)
                                .foregroundStyle(Palette.black)
                        }
                    }
                }
                .chartXAxis {
                    AxisMarks(values: chartData.map(\.month), stroke: StrokeStyle(lineWidth: 0))
                }
                .chartYAxis {
                    AxisMarks(position: .leading, values: .automatic)
                }
                .animation(.easeInOut, value: selectedMetric)
                .frame(height: 280)
                .chartOverlay { proxy in
                    GeometryReader { geometry in
                        let plotFrame = geometry[proxy.plotAreaFrame]
                        Rectangle()
                            .fill(.clear)
                            .contentShape(Rectangle())
                            .onTapGesture { location in
                                let x = location.x - plotFrame.origin.x
                                guard x >= 0, x <= plotFrame.width, !chartData.isEmpty else { return }
                                let index = Int(x / (plotFrame.width / CGFloat(chartData.count)))
                                guard index < chartData.count else { return }
                                let tapped = chartData[index].month
                                selectedMonth = selectedMonth == tapped ? nil : tapped
                            }
                    }
                }
            }
            .padding(16)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .background(RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Palette.white))
            .padding(.horizontal, 16)

            VStack(spacing: 16) {
                fuelAnalyticsRow(category: "Total cost", amount: appState.currency.format(displayedData.totalCost))
                Divider()
                    .overlay(Palette.greyLight)
                fuelAnalyticsRow(category: "Total liters", amount: String(format: "%.1f L", displayedData.totalLiters))
                Divider()
                    .overlay(Palette.greyLight)
                fuelAnalyticsRow(category: "Average liter price", amount: appState.currency.format(displayedData.averageCost))
                Divider()
                    .overlay(Palette.greyLight)
                fuelAnalyticsRow(category: "Refuels amount", amount: displayedData.refuelsAmount.description)
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
    }

    private func annotationText(for value: Float) -> String {
        switch selectedMetric {
        case .cost: appState.currency.format(value)
        case .liters: String(format: "%.1f L", value)
        case .avgPrice: appState.currency.format(value)
        case .refuels: "\(Int(value))"
        }
    }

    private func loadData() {
        let expenses = vehicleManager.fetchCurrentYear(modelContext: modelContext)
        monthlyDataByMonth = vehicleManager.getMonthlyDataByMonth(expenses: expenses)
        fullYearData = vehicleManager.getMonthlyFuelData(expenses: expenses)
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
    AnalyticsYearView()
        .environment(VehicleManager())
        .environmentObject(NavigationManager())
        .environment(AppState())
        .environment(SceneDelegate())
}
