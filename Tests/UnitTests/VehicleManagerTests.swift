//
//  VehicleManagerTests.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 24/04/26.
//

import Foundation
@testable import Pitstop_APP
import Testing

@Suite("VehicleManager - calculateTotalFuelEfficency")
struct TotalFuelEfficiencyTests {
    let manager = VehicleManager()

    @Test func emptyReturnsZero() {
        #expect(manager.calculateTotalFuelEfficency(efficencies: []) == 0)
    }

    @Test func singleValue() {
        #expect(manager.calculateTotalFuelEfficency(efficencies: [4.0]) == 4.0)
    }

    @Test func averagesCorrectly() {
        #expect(manager.calculateTotalFuelEfficency(efficencies: [4.0, 6.0]) == 5.0)
    }
}

@Suite("VehicleManager - calculateFuelEfficencyData")
struct FuelEfficiencyDataTests {
    let manager = VehicleManager()

    @Test func emptyExpensesReturnsEmpty() {
        #expect(manager.calculateFuelEfficencyData(expenses: []).isEmpty)
    }

    @Test func singleExpenseReturnsEmpty() {
        let exp = FuelExpense(totalCost: 50, quantity: 30, odometer: 10000, fuelType: .gasoline, date: .now, vehicle: nil)
        #expect(manager.calculateFuelEfficencyData(expenses: [exp]).isEmpty)
    }

    @Test func zeroDistanceSkipped() {
        // Same odometer = zero distance = no valid efficiency
        let date = Date()
        let exp1 = FuelExpense(totalCost: 50, quantity: 30, odometer: 10000, fuelType: .gasoline, date: date.addingTimeInterval(-86400), vehicle: nil)
        let exp2 = FuelExpense(totalCost: 50, quantity: 30, odometer: 10000, fuelType: .gasoline, date: date, vehicle: nil)
        #expect(manager.calculateFuelEfficencyData(expenses: [exp1, exp2]).isEmpty)
    }

    @Test func twoDifferentDaysProduceTwoEntries() {
        let now = Date()
        let exp1 = FuelExpense(totalCost: 50, quantity: 30, odometer: 10000, fuelType: .gasoline, date: now.addingTimeInterval(-2 * 86400), vehicle: nil)
        let exp2 = FuelExpense(totalCost: 60, quantity: 40, odometer: 14000, fuelType: .gasoline, date: now.addingTimeInterval(-86400), vehicle: nil)
        let exp3 = FuelExpense(totalCost: 70, quantity: 35, odometer: 18000, fuelType: .gasoline, date: now, vehicle: nil)
        let result = manager.calculateFuelEfficencyData(expenses: [exp1, exp2, exp3])
        #expect(result.count == 2)
    }

    @Test func sameDayExpensesGroupedAndAveraged() {
        let now = Date()
        let dayStart = Calendar.current.startOfDay(for: now)
        // exp1 → exp2: distance=5000, quantity=50 → efficiency=1.0
        // exp2 → exp3: distance=5000, quantity=25 → efficiency=0.5
        // both land on same day → average = 0.75
        let exp1 = FuelExpense(totalCost: 50, quantity: 30, odometer: 10000, fuelType: .gasoline, date: dayStart.addingTimeInterval(-86400), vehicle: nil)
        let exp2 = FuelExpense(totalCost: 50, quantity: 50, odometer: 15000, fuelType: .gasoline, date: dayStart.addingTimeInterval(3600), vehicle: nil)
        let exp3 = FuelExpense(totalCost: 50, quantity: 25, odometer: 20000, fuelType: .gasoline, date: dayStart.addingTimeInterval(7200), vehicle: nil)
        let result = manager.calculateFuelEfficencyData(expenses: [exp1, exp2, exp3])
        #expect(result.count == 1)
        #expect(abs(result[0].1 - 0.75) < 0.001)
    }
}

@Suite("VehicleManager - getMonthlyFuelData")
struct MonthlyFuelDataTests {
    let manager = VehicleManager()

    @Test func emptyExpensesReturnsZeros() {
        let data = manager.getMonthlyFuelData(expenses: [])
        #expect(data.totalCost == 0)
        #expect(data.averageCost == 0)
        #expect(data.refuelsAmount == 0)
        #expect(data.daysFromLastRefuel == 0)
    }

    @Test func totalCostAndRefuelCount() {
        let exp1 = FuelExpense(totalCost: Decimal(string: "30.00")!, quantity: 20, odometer: 10000, fuelType: .gasoline, date: .now, vehicle: nil)
        let exp2 = FuelExpense(totalCost: Decimal(string: "50.00")!, quantity: 30, odometer: 15000, fuelType: .gasoline, date: .now, vehicle: nil)
        let data = manager.getMonthlyFuelData(expenses: [exp1, exp2])
        #expect(data.totalCost == 80.0)
        #expect(data.refuelsAmount == 2)
    }

    @Test func averageCostPerUnit() {
        // totalCost=50, totalQuantity=25 → averageCost=2.0
        let exp = FuelExpense(totalCost: Decimal(string: "50.00")!, quantity: 25, odometer: 10000, fuelType: .gasoline, date: .now, vehicle: nil)
        let data = manager.getMonthlyFuelData(expenses: [exp])
        #expect(data.averageCost == 2.0)
    }

    @Test func daysFromLastRefuelNonNegative() {
        let exp = FuelExpense(totalCost: 50, quantity: 25, odometer: 10000, fuelType: .gasoline, date: .now, vehicle: nil)
        let data = manager.getMonthlyFuelData(expenses: [exp])
        #expect(data.daysFromLastRefuel >= 0)
    }
}
