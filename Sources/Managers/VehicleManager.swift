//
//  VehicleManager.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 28/12/24.
//

import Foundation
import Observation
import OSLog
import SwiftData

@Observable class VehicleManager {
    private(set) var currentVehicle: Vehicle = .mock()

    // MARK: Cached stats (refreshed via refreshStats)

    private(set) var sortedExpenses: [FuelExpense] = []
    private(set) var totalFuelCost: Decimal = 0
    private(set) var fuelEfficiency: Float?

    private let userDefaultsKey = "currentVehicleUUID"

    // MARK: Vehicle selection

    func fetchVehicleByUUID(uuid: UUID, modelContext: ModelContext) -> Vehicle? {
        do {
            let descriptor = FetchDescriptor<Vehicle>(
                predicate: #Predicate { vehicle in
                    vehicle.uuid == uuid
                }
            )
            let vehicles = try modelContext.fetch(descriptor)
            return vehicles.first
        } catch {
            Logger.manager.error("Error fetching vehicle by UUID: \(error)")
            return nil
        }
    }

    func loadCurrentVehicle(modelContext: ModelContext) {
        if let uuidString = UserDefaults.standard.string(forKey: userDefaultsKey),
           let uuid = UUID(uuidString: uuidString),
           let vehicle = fetchVehicleByUUID(uuid: uuid, modelContext: modelContext) {
            currentVehicle = vehicle
            refreshStats(modelContext: modelContext)
        }
    }

    func setCurrentVehicle(_ vehicle: Vehicle, modelContext: ModelContext? = nil) {
        currentVehicle = vehicle
        saveUUIDToUserDefaults(vehicle: vehicle)
        if let modelContext {
            refreshStats(modelContext: modelContext)
        }
    }

    // MARK: Cached stats

    /// Refreshes cached stats for the current vehicle. Call after insert/delete/vehicle change.
    func refreshStats(modelContext: ModelContext) {
        let uuid = currentVehicle.uuid
        let descriptor = FetchDescriptor<FuelExpense>(
            predicate: #Predicate { $0.vehicle?.uuid == uuid },
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        let expenses = (try? modelContext.fetch(descriptor)) ?? []

        sortedExpenses = expenses
        totalFuelCost = expenses.reduce(Decimal(0)) { $0 + $1.totalCost }
        fuelEfficiency = computeEfficiency(expenses: expenses)
    }

    private func computeEfficiency(expenses: [FuelExpense]) -> Float? {
        guard expenses.count > 1 else { return nil }

        let byOdometer = expenses.sorted { $0.odometer < $1.odometer }
        var totalFuel: Float = 0
        var totalDistance: Float = 0

        for i in 1 ..< byOdometer.count {
            let distance = byOdometer[i].odometer - byOdometer[i - 1].odometer
            if distance > 0 {
                totalDistance += Float(distance)
                totalFuel += byOdometer[i].quantity
            }
        }

        guard totalDistance > 0 else { return nil }
        return (totalFuel / totalDistance) * 100
    }

    // MARK: Date-range stats (fetched on demand, not cached)

    /// Fetches fuel expenses for the current vehicle within the last 30 days.
    /// Uses FetchDescriptor + predicate + date index for O(log n) filtering.
    func fetchLast30Days(modelContext: ModelContext, from referenceDate: Date = .now) -> [FuelExpense] {
        guard let cutoff = Calendar.current.date(byAdding: .day, value: -30, to: referenceDate) else {
            return []
        }
        let uuid = currentVehicle.uuid
        let descriptor = FetchDescriptor<FuelExpense>(
            predicate: #Predicate {
                $0.vehicle?.uuid == uuid && $0.date >= cutoff && $0.date <= referenceDate
            },
            sortBy: [SortDescriptor(\.date)]
        )
        return (try? modelContext.fetch(descriptor)) ?? []
    }

    func fetchCurrentYear(modelContext: ModelContext) -> [FuelExpense] {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: .now)
        guard
            let start = calendar.date(from: DateComponents(year: year, month: 1, day: 1)),
            let end = calendar.date(from: DateComponents(year: year + 1, month: 1, day: 1))
        else { return [] }
        let uuid = currentVehicle.uuid
        let descriptor = FetchDescriptor<FuelExpense>(
            predicate: #Predicate { $0.vehicle?.uuid == uuid && $0.date >= start && $0.date < end },
            sortBy: [SortDescriptor(\.date)]
        )
        return (try? modelContext.fetch(descriptor)) ?? []
    }

    func getYearlyChartData(expenses: [FuelExpense]) -> [(month: String, value: Float)] {
        let calendar = Calendar.current
        let symbols = calendar.shortMonthSymbols
        var grouped: [Int: Float] = [:]
        for expense in expenses {
            let month = calendar.component(.month, from: expense.date)
            grouped[month, default: 0] += NSDecimalNumber(decimal: expense.totalCost).floatValue
        }
        return (1 ... 12).map { month in (month: symbols[month - 1], value: grouped[month] ?? 0) }
    }

    func getMonthlyDataByMonth(expenses: [FuelExpense]) -> [String: MonthlyFuelData] {
        let calendar = Calendar.current
        let symbols = calendar.shortMonthSymbols
        var grouped: [Int: [FuelExpense]] = [:]
        for expense in expenses {
            let month = calendar.component(.month, from: expense.date)
            grouped[month, default: []].append(expense)
        }
        return grouped.reduce(into: [:]) { result, pair in
            result[symbols[pair.key - 1]] = getMonthlyFuelData(expenses: pair.value)
        }
    }

    func getMonthlyFuelData(expenses: [FuelExpense]) -> MonthlyFuelData {
        let totalCost = expenses.reduce(Decimal(0)) { $0 + $1.totalCost }
        let daysFromLastRefuel = expenses.last.flatMap { expense in
            Calendar.current.dateComponents([.day], from: expense.date, to: Date()).day
        } ?? 0
        let totalQuantity = expenses.reduce(Float(0)) { $0 + $1.quantity }
        let averageCost = totalQuantity > 0
            ? totalCost / Decimal(Double(totalQuantity))
            : Decimal(0)

        return MonthlyFuelData(
            totalCost: NSDecimalNumber(decimal: totalCost).floatValue,
            totalLiters: totalQuantity.rounded(toPlaces: 2),
            averageCost: NSDecimalNumber(decimal: averageCost).floatValue.rounded(toPlaces: 2),
            refuelsAmount: expenses.count,
            daysFromLastRefuel: daysFromLastRefuel
        )
    }

    func calculateCostPerKmData(expenses: [FuelExpense]) -> [(String, Float)] {
        guard expenses.count > 1 else { return [] }
        let calendar = Calendar.current
        var dailyCosts: [Date: [Float]] = [:]

        for i in 1 ..< expenses.count {
            let prev = expenses[i - 1]
            let curr = expenses[i]
            let distance = curr.odometer - prev.odometer
            guard distance > 0 else { continue }
            let costPerKm = NSDecimalNumber(decimal: curr.totalCost).floatValue / Float(distance)
            let dayStart = calendar.startOfDay(for: curr.date)
            dailyCosts[dayStart, default: []].append(costPerKm)
        }

        return dailyCosts
            .sorted { $0.key < $1.key }
            .map { date, values in
                (date.toString(dateFormat: "MMM dd"), values.reduce(0, +) / Float(values.count))
            }
    }

    func calculateFuelEfficencyData(expenses: [FuelExpense]) -> [(String, Float)] {
        guard expenses.count > 1 else { return [] }

        let calendar = Calendar.current
        var dailyEfficiencies: [Date: [Float]] = [:]

        for i in 1 ..< expenses.count {
            let previousExpense = expenses[i - 1]
            let currentExpense = expenses[i]

            guard let efficiency = calculateFuelEfficiency(
                previousOdometer: previousExpense.odometer,
                currentOdometer: currentExpense.odometer,
                currentFuelQuantity: currentExpense.quantity
            ) else {
                continue
            }

            let dayStart = calendar.startOfDay(for: currentExpense.date)
            dailyEfficiencies[dayStart, default: []].append(efficiency)
        }

        return dailyEfficiencies
            .sorted { $0.key < $1.key }
            .map { date, efficiencies in
                let average = efficiencies.reduce(0, +) / Float(efficiencies.count)
                return (date.toString(dateFormat: "MMM dd"), average)
            }
    }

    func calculateTotalFuelEfficency(efficencies: [Float]) -> Float {
        guard !efficencies.isEmpty else { return 0 }
        return efficencies.reduce(0, +) / Float(efficencies.count)
    }

    // MARK: Odometer validation

    func validateOdometer(_ odometer: Int, for designatedDate: Date) -> OdometerValidationError? {
        let vehicle = currentVehicle
        let sortedExpenses = vehicle.fuelExpenses.sorted { $0.date < $1.date }

        guard !sortedExpenses.isEmpty else {
            return odometer > vehicle.initialOdometer ? nil : .belowInitialOdometer(initial: vehicle.initialOdometer)
        }

        if let firstExpense = sortedExpenses.first, designatedDate < firstExpense.date {
            return odometer <= firstExpense.odometer ? nil : .exceedsFirstEntry(first: firstExpense.odometer)
        }

        if let lastExpense = sortedExpenses.last, designatedDate > lastExpense.date {
            return odometer > vehicle.currentOdometer ? nil : .belowCurrentOdometer(current: vehicle.currentOdometer)
        }

        guard let index = sortedExpenses.firstIndex(where: { $0.date >= designatedDate }) else {
            if let lastExpense = sortedExpenses.last, lastExpense.odometer > odometer {
                return .belowPreviousEntry(previous: lastExpense.odometer)
            }
            return nil
        }

        let closestBefore = index > 0 ? sortedExpenses[index - 1] : nil
        let boundary = sortedExpenses[index]

        // When boundary is strictly after designatedDate, it is the upper constraint.
        // When boundary is on the same date, the next expense is the upper constraint.
        let closestAfter: FuelExpense? = boundary.date > designatedDate
            ? boundary
            : (index < sortedExpenses.count - 1 ? sortedExpenses[index + 1] : nil)

        if let before = closestBefore, before.odometer > odometer { return .belowPreviousEntry(previous: before.odometer) }
        if let after = closestAfter, after.odometer < odometer { return .exceedsNextEntry(next: after.odometer) }

        return nil
    }


    private func calculateFuelEfficiency(
        previousOdometer: Int,
        currentOdometer: Int,
        currentFuelQuantity: Float
    ) -> Float? {
        let distanceTraveled = currentOdometer - previousOdometer
        guard distanceTraveled > 0, currentFuelQuantity > 0 else { return nil }
        return (currentFuelQuantity / Float(distanceTraveled)) * 100
    }

    private func saveUUIDToUserDefaults(vehicle: Vehicle) {
        UserDefaults.standard.set(vehicle.uuid.uuidString, forKey: userDefaultsKey)
    }
}

struct MonthlyFuelData {
    var totalCost: Float = 0
    var totalLiters: Float = 0
    var averageCost: Float = 0
    var refuelsAmount: Int = 0
    var daysFromLastRefuel: Int = 0
}

enum OdometerValidationError: LocalizedError, Equatable {
    case belowInitialOdometer(initial: Int)
    case exceedsFirstEntry(first: Int)
    case belowCurrentOdometer(current: Int)
    case belowPreviousEntry(previous: Int)
    case exceedsNextEntry(next: Int)

    var errorDescription: String? {
        switch self {
        case let .belowInitialOdometer(initial):
            "Must be greater than the initial odometer (\(initial))."
        case let .exceedsFirstEntry(first):
            "Must be ≤ your first recorded entry (\(first))."
        case let .belowCurrentOdometer(current):
            "Must be greater than your latest entry (\(current))."
        case let .belowPreviousEntry(previous):
            "Must be greater than the previous entry (\(previous))."
        case let .exceedsNextEntry(next):
            "Must be less than the next entry (\(next))."
        }
    }
}
