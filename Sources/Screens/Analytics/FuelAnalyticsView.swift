//
//  FuelAnalyticsView.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 09/01/25.
//

import Charts
import SwiftUI

struct FuelAnalyticsView: View {
    @EnvironmentObject var vehicleManager: VehicleManager
    @State private var animatedData: [(month: String, value: Float)] = []

    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 26) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("8.71 L/100 km")
                            .font(Typography.headerL)
                            .foregroundStyle(Palette.black)
                        Text("Efficiency")
                            .font(Typography.headerS)
                            .foregroundStyle(Palette.greyMiddle)
                    }
                    Spacer()
                    HStack {
                        Image(.arrowAnalytics)
                        Text("12 %")
                    }
                }
                Chart {
                    ForEach(animatedData, id: \.month) { item in
                        LineMark(
                            x: .value("Month", item.month),
                            y: .value("Value", item.value)
                        )
                        .foregroundStyle(.green)
                        .lineStyle(StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                        .interpolationMethod(.cardinal)

                        AreaMark(
                            x: .value("Month", item.month),
                            y: .value("Value", item.value)
                        )
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Palette.chartGreen.opacity(0.3), Palette.chartGreen.opacity(0)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    }
                }
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
                fuelAnalyticsRow(category: "Test", amount: "$ 84")
                Divider()
                    .overlay(Palette.greyLight)
                fuelAnalyticsRow(category: "Test", amount: "$ 84")
                Divider()
                    .overlay(Palette.greyLight)
                fuelAnalyticsRow(category: "Test", amount: "$ 84")
                Divider()
                    .overlay(Palette.greyLight)
                fuelAnalyticsRow(category: "Test", amount: "$ 84")
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
            vehicleManager.getMonthlyFuelEfficency()
        }
    }

    private func animateChart() {
        animatedData = [] // Start with no data
        for (index, value) in vehicleManager.monthlyFuelEfficency.enumerated() {
            withAnimation(.interactiveSpring(duration: 0.3).delay(Double(index) * 0.1)) {
                animatedData.append((month: value.key, value: value.value))
            }
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
    FuelAnalyticsView()
}
