//
//  FuelModelTests.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 10/01/25.
//

import Foundation
@testable import Pitstop_APP
import SwiftData
import Testing

@Suite("FuelExpense - pricePerUnit")
struct FuelExpensePriceTests {
    @Test func normalCase() {
        let expense = FuelExpense(
            totalCost: Decimal(string: "50.00")!,
            quantity: 20.0,
            odometer: 1000,
            fuelType: .gasoline,
            date: .now,
            vehicle: nil
        )
        #expect(expense.pricePerUnit == Decimal(string: "2.5")!)
    }

    @Test func zeroQuantityReturnsZero() {
        let expense = FuelExpense(totalCost: 50, quantity: 0, odometer: 1000, fuelType: .gasoline, date: .now, vehicle: nil)
        #expect(expense.pricePerUnit == 0)
    }

    @Test func zeroCostReturnsZero() {
        let expense = FuelExpense(totalCost: 0, quantity: 20, odometer: 1000, fuelType: .gasoline, date: .now, vehicle: nil)
        #expect(expense.pricePerUnit == 0)
    }
}

@Suite("VehicleManager - isValidOdometer")
actor OdometerValidationTests {
    let context: ModelContext
    let manager: VehicleManager
    var vehicle: Vehicle

    init() async throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Vehicle.self, FuelExpense.self, configurations: config)
        context = ModelContext(container)
        vehicle = Vehicle(name: "Test", brand: "Brand", model: "X", initialOdometer: 10000)
        context.insert(vehicle)
        try context.save()
        manager = VehicleManager()
        manager.setCurrentVehicle(vehicle)
    }

    private func addExpense(odometer: Int, daysOffset: Double) {
        let date = Date().addingTimeInterval(daysOffset * 86400)
        let exp = FuelExpense(totalCost: 50, quantity: 30, odometer: odometer, fuelType: .gasoline, date: date, vehicle: vehicle)
        context.insert(exp)
        #expect(!vehicle.fuelExpenses.isEmpty, "SwiftData inverse relationship not populated — odometer tests are meaningless")
    }

    // MARK: No expenses

    @Test func noExpenses_aboveInitial_valid() {
        #expect(manager.validateOdometer(10001, for: .now) == nil)
    }

    @Test func noExpenses_equalOrBelowInitial_invalid() {
        #expect(manager.validateOdometer(10000, for: .now) == .belowInitialOdometer(initial: 10000))
        #expect(manager.validateOdometer(9999, for: .now) == .belowInitialOdometer(initial: 10000))
    }

    // MARK: Before first expense

    @Test func beforeFirstExpense_odometerBelowFirst_valid() {
        addExpense(odometer: 15000, daysOffset: -5)
        let dateBefore = Date().addingTimeInterval(-10 * 86400)
        #expect(manager.validateOdometer(12000, for: dateBefore) == nil)
    }

    @Test func beforeFirstExpense_odometerAboveFirst_invalid() {
        addExpense(odometer: 15000, daysOffset: -5)
        let dateBefore = Date().addingTimeInterval(-10 * 86400)
        #expect(manager.validateOdometer(16000, for: dateBefore) == .exceedsFirstEntry(first: 15000))
    }

    // MARK: After last expense

    @Test func afterLastExpense_higherOdometer_valid() {
        addExpense(odometer: 15000, daysOffset: -5)
        addExpense(odometer: 20000, daysOffset: -1)
        #expect(manager.validateOdometer(21000, for: .now) == nil)
    }

    @Test func afterLastExpense_lowerOdometer_invalid() {
        addExpense(odometer: 15000, daysOffset: -5)
        addExpense(odometer: 20000, daysOffset: -1)
        #expect(manager.validateOdometer(19000, for: .now) == .belowCurrentOdometer(current: 20000))
    }

    // MARK: Between two expenses

    @Test func betweenExpenses_validOdometer() {
        addExpense(odometer: 10000, daysOffset: -10)
        addExpense(odometer: 20000, daysOffset: -2)
        let dateBetween = Date().addingTimeInterval(-6 * 86400)
        #expect(manager.validateOdometer(15000, for: dateBetween) == nil)
    }

    @Test func betweenExpenses_odometerTooHigh_invalid() {
        addExpense(odometer: 10000, daysOffset: -10)
        addExpense(odometer: 20000, daysOffset: -2)
        let dateBetween = Date().addingTimeInterval(-6 * 86400)
        #expect(manager.validateOdometer(25000, for: dateBetween) == .exceedsNextEntry(next: 20000))
    }

    @Test func betweenExpenses_odometerTooLow_invalid() {
        addExpense(odometer: 10000, daysOffset: -10)
        addExpense(odometer: 20000, daysOffset: -2)
        let dateBetween = Date().addingTimeInterval(-6 * 86400)
        #expect(manager.validateOdometer(5000, for: dateBetween) == .belowPreviousEntry(previous: 10000))
    }
}
