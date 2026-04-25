//
//  Vehicle.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 27/12/24.
//

import Foundation
import OSLog
import SwiftData

@Model
final class Vehicle {
    @Attribute(.unique)
    var uuid: UUID

    var brand: String
    var model: String
    var mainFuelType: FuelType
    var initialOdometer: Int
    var plate: String? //

    // TODO: Replace with CNContact identifiers array
    @Relationship(deleteRule: .cascade, inverse: \Number.vehicle)
    var numbers: [Number] = []

    @Relationship(deleteRule: .cascade, inverse: \FuelExpense.vehicle)
    var fuelExpenses: [FuelExpense] = []

    /// The live odometer reading, derived from the most recent fuel expense.
    /// Falls back to `initialOdometer` when no expenses exist yet. O(n) single-pass.
    var currentOdometer: Int {
        fuelExpenses.max(by: { $0.date < $1.date })?.odometer ?? initialOdometer
    }

    var displayName: String { "\(brand) \(model)" }

    init(
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

    func saveToModelContext(context: ModelContext) throws {
        let name = displayName
        context.insert(self)
        try context.save()
        Logger.persistence.debug("Vehicle \(name) saved successfully")
    }

    static func mock() -> Vehicle {
        Vehicle(brand: "Brand", model: "XYZ", initialOdometer: 0)
    }
}
