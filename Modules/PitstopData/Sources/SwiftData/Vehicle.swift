//
//  Vehicle.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 27/12/24.
//

import Foundation
import OSLog
import SwiftData

private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.pitstop", category: "persistence")

@Model
public final class Vehicle {
    @Attribute(.unique)
    public var uuid: UUID

    public var brand: String
    public var model: String
    public var mainFuelType: FuelType
    public var initialOdometer: Int
    public var plate: String?

    // TODO: Replace with CNContact identifiers array
    @Relationship(deleteRule: .cascade, inverse: \Number.vehicle)
    public var numbers: [Number] = []

    @Relationship(deleteRule: .cascade, inverse: \FuelExpense.vehicle)
    public var fuelExpenses: [FuelExpense] = []

    /// The live odometer reading, derived from the most recent fuel expense.
    /// Falls back to `initialOdometer` when no expenses exist yet. O(n) single-pass.
    public var currentOdometer: Int {
        fuelExpenses.max(by: { $0.date < $1.date })?.odometer ?? initialOdometer
    }

    public var displayName: String { "\(brand) \(model)" }

    public init(
        uuid: UUID = UUID(),
        brand: String,
        model: String,
        mainFuelType: FuelType = .gasoline,
        initialOdometer: Int,
        plate: String? = nil
    ) {
        self.uuid = uuid
        self.brand = brand
        self.model = model
        self.mainFuelType = mainFuelType
        self.initialOdometer = initialOdometer
        self.plate = plate
    }

    public func saveToModelContext(context: ModelContext) throws {
        let name = displayName
        context.insert(self)
        try context.save()
        logger.debug("Vehicle \(name) saved successfully")
    }

    public static func mock() -> Vehicle {
        Vehicle(brand: "Brand", model: "XYZ", initialOdometer: 0)
    }
}
