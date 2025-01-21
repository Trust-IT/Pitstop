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
@preconcurrency struct FuelModelTests {
    let vehicle: Vehicle = .mock()
    let modelContainer: ModelContainer

    init() {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        do {
            modelContainer = try ModelContainer(
                for: Vehicle.self,
                FuelExpense.self,
                configurations: config
            )
        } catch {
            fatalError("Could not initialize ModelContainer")
        }
        populateVehicleWithFuelExpenses()
    }

    func populateVehicleWithFuelExpenses() {
        let fuelExpenses = [
            FuelExpense(
                totalPrice: 50.0,
                quantity: 20.0,
                pricePerUnit: 2.5,
                odometer: 10000,
                fuelType: .gasoline,
                date: Date().addingTimeInterval(-86400),
                vehicle: vehicle
            ),
            FuelExpense(
                totalPrice: 60.0,
                quantity: 25.0,
                pricePerUnit: 2.4,
                odometer: 15000,
                fuelType: .diesel,
                date: Date().addingTimeInterval(-43200),
                vehicle: vehicle
            ),
            FuelExpense(
                totalPrice: 60.0,
                quantity: 25.0,
                pricePerUnit: 2.4,
                odometer: 15000,
                fuelType: .diesel,
                date: Date().addingTimeInterval(-26600),
                vehicle: vehicle
            ),
            FuelExpense(
                totalPrice: 70.0,
                quantity: 30.0,
                pricePerUnit: 2.3,
                odometer: 20000,
                fuelType: .gasoline,
                date: Date(),
                vehicle: vehicle
            )
        ]
        vehicle.fuelExpenses = fuelExpenses
        Task { @MainActor in
            modelContainer.mainContext.insert(vehicle)
        }
    }

    func deleteFuelExpenses() {
        Task { @MainActor in
            for expense in vehicle.fuelExpenses {
                modelContainer.mainContext.delete(expense)
            }
        }
        vehicle.fuelExpenses = []
    }

    // Test case 1: Valid odometer reading between two existing expenses
    @Test func validOdometerBetweenExpenses() throws {
        // Create a FuelExpense with a valid odometer value between 15000 and 20000
        let validFuelExpense = FuelExpense(
            totalPrice: 55.0,
            quantity: 22.0,
            pricePerUnit: 2.5,
            odometer: 17500,
            fuelType: .gasoline,
            date: Date().addingTimeInterval(-21600),
            vehicle: vehicle
        )

        // Test the validity of the odometer reading
        try #require(validFuelExpense.isValidOdometer(for: vehicle) == true)
    }

    // Test case 2: Odometer reading lower than previous expense
    @Test func odometerLowerThanPreviousExpense() throws {
        // Create a FuelExpense with an invalid odometer value lower than the previous (15000)
        let invalidFuelExpense = FuelExpense(
            totalPrice: 55.0,
            quantity: 22.0,
            pricePerUnit: 2.5,
            odometer: 14000,
            fuelType: .gasoline,
            date: Date().addingTimeInterval(-21600),
            vehicle: vehicle
        )

        try #require(invalidFuelExpense.isValidOdometer(for: vehicle) == false)
    }

    // Test case 3: Odometer reading higher than next expense
    @Test func odometerHigherThanNextExpense() throws {
        // Create a FuelExpense with an invalid odometer value higher than the next (20000)
        let invalidFuelExpense = FuelExpense(
            totalPrice: 55.0,
            quantity: 22.0,
            pricePerUnit: 2.5,
            odometer: 25000,
            fuelType: .gasoline,
            date: Date().addingTimeInterval(-21600),
            vehicle: vehicle
        )

        try #require(invalidFuelExpense.isValidOdometer(for: vehicle) == false)
    }

    // Test case 4: Odometer reading lower than last expense
    @Test func odometerLowerThanLastExpense() throws {
        // Create a FuelExpense with an invalid odometer value lower than the last one (20000)
        let invalidFuelExpense = FuelExpense(
            totalPrice: 55.0,
            quantity: 22.0,
            pricePerUnit: 2.5,
            odometer: 19000,
            fuelType: .gasoline,
            date: Date(),
            vehicle: vehicle
        )

        try #require(invalidFuelExpense.isValidOdometer(for: vehicle) == false)
    }

    // Test case 5: Odometer higher than first expense
    @Test func odometerHigherThanFirstExpense() throws {
        // Create a FuelExpense with a higher odometer value than the first expense (10000)
        let validFuelExpense = FuelExpense(
            totalPrice: 55.0,
            quantity: 22.0,
            pricePerUnit: 2.5,
            odometer: 11000,
            fuelType: .gasoline,
            date: Date().addingTimeInterval(-61600), // 1 day before the first expense
            vehicle: vehicle
        )
        try #require(validFuelExpense.isValidOdometer(for: vehicle) == true)
    }

    // Test case 6: Odometer higher than first expense
    @Test func odometerAsFirstExpense() throws {
        // Create a FuelExpense with a higher odometer value than the first expense (10000)
        let invalidFuelExpense = FuelExpense(
            totalPrice: 55.0,
            quantity: 22.0,
            pricePerUnit: 2.5,
            odometer: 11000,
            fuelType: .gasoline,
            date: Date().addingTimeInterval(-90000),
            vehicle: vehicle
        )
        try #require(invalidFuelExpense.isValidOdometer(for: vehicle) == false)
    }

    // Test case 7: Odometer higher value between two equal odometer value
    @Test func odometerBetweenDuplicateOdometerValues() throws {
        let invalidExpense = FuelExpense(
            totalPrice: 55.0,
            quantity: 22.0,
            pricePerUnit: 2.5,
            odometer: 16000,
            fuelType: .diesel,
            date: Date().addingTimeInterval(-35000), // This places the expense between the two 15000 ones
            vehicle: vehicle
        )
        try #require(invalidExpense.isValidOdometer(for: vehicle) == false)
    }

    // Test case 8: Odometer iserted when no previous expenses
    @Test func odometerWithNoExpenses() throws {
        deleteFuelExpenses()

        let invalidFuelExpense = FuelExpense(
            totalPrice: 55.0,
            quantity: 22.0,
            pricePerUnit: 2.5,
            odometer: 19000,
            fuelType: .gasoline,
            date: Date(),
            vehicle: vehicle
        )

        try #require(invalidFuelExpense.isValidOdometer(for: vehicle) == true)
    }
}
