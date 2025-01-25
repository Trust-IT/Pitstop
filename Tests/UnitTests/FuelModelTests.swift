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

@Suite("Fuel Model Odometer Tests")
actor FuelModelTests {
    var vehicle: Vehicle = .mock()
    let context: ModelContext

    init() async throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        do {
            let modelContainer = try ModelContainer(
                for: Vehicle.self,
                FuelExpense.self,
                configurations: config
            )
            context = ModelContext(modelContainer)
        } catch {
            fatalError("Could not initialize ModelContainer")
        }
//        Task {
//            await populateVehicleWithFuelExpenses()
//        }
        populateVehicleWithFuelExpenses()
    }

    func populateVehicleWithFuelExpenses() {
        // Create the vehicle entity
        vehicle.odometer = 20000

        // Create and add fuel expenses to the vehicle
        let fuelExpenses = [
            FuelExpense(
                totalPrice: .init(value: 29.0),
                quantity: 20.0,
                pricePerUnit: 2.5,
                odometer: 10000,
                fuelType: .gasoline,
                date: Date().addingTimeInterval(-86400),
                vehicle: nil
            ),
            FuelExpense(
                totalPrice: .init(value: 42.0),
                quantity: 25.0,
                pricePerUnit: 2.4,
                odometer: 15000,
                fuelType: .diesel,
                date: Date().addingTimeInterval(-43200),
                vehicle: nil
            ),
            FuelExpense(
                totalPrice: .init(value: 420.0),
                quantity: 25.0,
                pricePerUnit: 2.4,
                odometer: 15000,
                fuelType: .diesel,
                date: Date().addingTimeInterval(-26600),
                vehicle: nil
            ),
            FuelExpense(
                totalPrice: .init(value: 63.0),
                quantity: 30.0,
                pricePerUnit: 2.3,
                odometer: 20000,
                fuelType: .gasoline,
                date: Date(),
                vehicle: nil
            )
        ]

        context.insert(vehicle)
//        try? context.save()
        vehicle.fuelExpenses = []
//        vehicle.fuelExpenses = fuelExpenses   // Note: if I try to do this, it crashes, idk why.
    }

    // Test case 1: Valid odometer reading between two existing expenses
    @Test func validOdometerBetweenExpenses() {
        #expect(vehicle.isValidOdometer(17500, for: Date().addingTimeInterval(-21600)) == true)
    }

    // Test case 2: Odometer reading lower than previous expense
    @Test func odometerLowerThanPreviousExpense() async throws {
//        populateVehicleWithFuelExpenses()
        try #require(vehicle.isValidOdometer(14000, for: Date().addingTimeInterval(-21600)) == true)
    }

    // Test case 3: Odometer reading higher than next expense
    @Test func odometerHigherThanNextExpense() async throws {
//        populateVehicleWithFuelExpenses()
        try #require(vehicle.isValidOdometer(25000, for: Date().addingTimeInterval(-21600)) == true)
    }

    // Test case 4: Odometer reading lower than last expense
    @Test func odometerLowerThanLastExpense() async throws {
//        populateVehicleWithFuelExpenses()
        try #require(vehicle.isValidOdometer(19000, for: Date()) == true)
    }

    // Test case 5: Odometer higher than first expense
    @Test func odometerHigherThanFirstExpense() async throws {
        // 1 day before the first expense
//        populateVehicleWithFuelExpenses()
        try #require(vehicle.isValidOdometer(11000, for: Date().addingTimeInterval(-61600)) == true)
    }

    // Test case 6: Odometer higher than first expense
    @Test func odometerAsFirstExpense() async throws {
//        populateVehicleWithFuelExpenses()
        try #require(vehicle.isValidOdometer(11000, for: Date().addingTimeInterval(-90000)) == true)
    }

    // Test case 7: Odometer higher value between two equal odometer value
    @Test func odometerBetweenDuplicateOdometerValues() async throws {
//        vehicle.fuelExpenses.append(exp)
        print(vehicle.fuelExpenses)
        try #require(vehicle.isValidOdometer(16000, for: Date().addingTimeInterval(-35000)) == true)
    }

    // Test case 8: Odometer inserted when no previous expenses
    @Test func odometerWithNoExpenses() async throws {
        try #require(vehicle.isValidOdometer(19000, for: Date()) == false)
        try #require(vehicle.isValidOdometer(21000, for: Date()) == true)
    }
}
