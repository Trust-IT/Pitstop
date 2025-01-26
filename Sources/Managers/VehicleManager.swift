//
//  VehicleManager.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 28/12/24.
//

import Foundation
import SwiftData

class VehicleManager: ObservableObject {
    @Published private(set) var currentVehicle: Vehicle = .mock()
    @Published var monthlyFuelEfficency: [String: Float] = [:]

    private let userDefaultsKey = "currentVehicleUUID"

    func fetchVehicleByUUID(uuid: UUID, modelContext: ModelContext) -> Vehicle? {
        do {
            let descriptor = FetchDescriptor<Vehicle>(
                predicate: #Predicate { vehicle in
                    vehicle.uuid == uuid
                }
            )

            // Perform the fetch using the descriptor
            let vehicles = try modelContext.fetch(descriptor)
            return vehicles.first // Return the first matching vehicle, if any
        } catch {
            print("Error fetching vehicle by UUID: \(error)")
            return nil
        }
    }

    func loadCurrentVehicle(modelContext: ModelContext) {
        if let uuidString = UserDefaults.standard.string(forKey: userDefaultsKey),
           let uuid = UUID(uuidString: uuidString),
           let vehicle = fetchVehicleByUUID(uuid: uuid, modelContext: modelContext) {
            currentVehicle = vehicle
        }
    }

    func setCurrentVehicle(_ vehicle: Vehicle) {
        currentVehicle = vehicle
        saveUUIDToUserDefaults(vehicle: vehicle)
    }

    func getMonthlyFuelEfficency() {
        guard currentVehicle.fuelExpenses.count > 1 else {
            return
        }

        // Group fuel expenses by month and year
        let groupedByMonth = Dictionary(grouping: currentVehicle.fuelExpenses) { expense -> String in
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM"
            return formatter.string(from: expense.date)
        }

        for (month, expenses) in groupedByMonth {
            let sortedExpenses = expenses.sorted { $0.odometer < $1.odometer }

            var totalFuelConsumed: Float = 0
            var totalDistanceTraveled: Float = 0

            for i in 1 ..< sortedExpenses.count {
                let previousExpense = sortedExpenses[i - 1]
                let currentExpense = sortedExpenses[i]

                // Calculate the distance traveled
                let distance = currentExpense.odometer - previousExpense.odometer
                if distance > 0 {
                    totalDistanceTraveled += distance
                    totalFuelConsumed += currentExpense.quantity
                }
            }

            // Check if we can calculate efficiency for this month
            guard totalDistanceTraveled > 0 else { continue }

            let efficiency = (totalFuelConsumed / totalDistanceTraveled) * 100
            monthlyFuelEfficency[month] = efficiency
        }
    }

    func calculateFuelEfficiency(
        previousOdometer: Float,
        currentOdometer: Float,
        currentFuelQuantity: Float
    ) -> Float? {
        let distanceTraveled = currentOdometer - previousOdometer

        guard distanceTraveled > 0, currentFuelQuantity > 0 else {
            return nil
        }

        return (currentFuelQuantity / distanceTraveled) * 100
    }

    func filterFuelExpensesLast30Days(expenses: [FuelExpense], from referenceDate: Date = Date()) -> [FuelExpense] {
        let calendar = Calendar.current

        guard let startDate = calendar.date(byAdding: .day, value: -30, to: referenceDate) else {
            return []
        }

        return expenses.filter { $0.date >= startDate && $0.date <= referenceDate }
    }

    func calculateFuelEfficencyData(expenses: [FuelExpense], from referenceDate: Date = Date()) -> [(String, Float)] {
        guard expenses.count > 1 else {
            return []
        }

        let filteredExpenses = filterFuelExpensesLast30Days(expenses: expenses, from: referenceDate)

        let sortedExpenses = filteredExpenses.sorted { $0.date < $1.date }

        var dailyEfficiencies: [String: [Float]] = [:]

        for i in 1 ..< sortedExpenses.count {
            let previousExpense = sortedExpenses[i - 1]
            let currentExpense = sortedExpenses[i]

            // Calculate efficiency using consecutive fuel expenses
            guard let efficiency = calculateFuelEfficiency(
                previousOdometer: previousExpense.odometer,
                currentOdometer: currentExpense.odometer,
                currentFuelQuantity: currentExpense.quantity
            ) else {
                continue
            }

            let dateString = currentExpense.date.toString(dateFormat: "MMM dd")

            if dailyEfficiencies[dateString] != nil {
                dailyEfficiencies[dateString]?.append(efficiency)
            } else {
                dailyEfficiencies[dateString] = [efficiency]
            }
        }
        return dailyEfficiencies.map { date, efficiencies in
            let averageEfficiency = efficiencies.reduce(0, +) / Float(efficiencies.count)
            return (date, averageEfficiency)
        }.sorted { $0.0 < $1.0 }
    }

    func calculateTotalFuelEfficency(efficencies: [Float]) -> Float {
        guard !efficencies.isEmpty else {
            return 0
        }
        return efficencies.reduce(0, +) / Float(efficencies.count)
    }

    private func getExpensesCost(for expenses: [FuelExpense]) -> Float {
        guard !expenses.isEmpty else { return 0 }
        return expenses
            .map(\.totalPrice.amount.floatValue)
            .reduce(0, +)
    }

    private func getAverageFuelCost(for expenses: [FuelExpense]) -> Float {
        guard !expenses.isEmpty else { return 0 }
        let totalCost = expenses
            .map(\.pricePerUnit)
            .reduce(0, +)
        return totalCost / Float(expenses.count)
    }

    func getMonthlyFuelData() -> MonthlyFuelData {
        let lastMonthExpenses = filterFuelExpensesLast30Days(expenses: currentVehicle.fuelExpenses)
        let totalCost = getExpensesCost(for: lastMonthExpenses)
        let refuelsAmount = lastMonthExpenses.count
        let daysFromLastRefuel = Calendar.current.dateComponents([.day],
                                                                 from: lastMonthExpenses.last?.date ?? Date(),
                                                                 to: Date()).day ?? 0
        let averageCost = getAverageFuelCost(for: lastMonthExpenses)
        return MonthlyFuelData(
            totalCost: totalCost,
            averageCost: averageCost,
            refuelsAmount: refuelsAmount,
            daysFromLastRefuel: daysFromLastRefuel
        )
    }

    private func saveUUIDToUserDefaults(vehicle: Vehicle) {
        UserDefaults.standard.set(vehicle.uuid.uuidString, forKey: userDefaultsKey)
    }
}

// TODO: Implement
struct MonthlyFuelData {
    var totalCost: Float = 0
    var averageCost: Float = 0
    var refuelsAmount: Int = 0
    var daysFromLastRefuel: Int = 0
}
