//
//  Vehicle.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 27/12/24.
//

import Foundation
import SwiftData

@Model
final class Vehicle {
    @Attribute(.unique)
    var uuid: UUID

    var name: String
    var brand: String
    var model: String
    var mainFuelType: FuelType
    var secondaryFuelType: FuelType?
    var initialOdometer: Int
    var plate: String?

    @Relationship(deleteRule: .cascade, inverse: \Number.vehicle)
    var numbers: [Number] = []

    @Relationship(deleteRule: .cascade, inverse: \FuelExpense.vehicle)
    var fuelExpenses: [FuelExpense] = []

    var sortedFuelExpenses: [FuelExpense] {
        fuelExpenses.sorted { $0.date > $1.date }
    }

    /// The live odometer reading, derived from the most recent fuel expense.
    /// Falls back to `initialOdometer` when no expenses exist yet.
    var currentOdometer: Int {
        fuelExpenses.sorted { $0.date > $1.date }.first.map { Int($0.odometer) } ?? initialOdometer
    }

    init(
        uuid: UUID = UUID(),
        name: String,
        brand: String,
        model: String,
        mainFuelType: FuelType = .gasoline,
        secondaryFuelType: FuelType? = nil,
        initialOdometer: Int,
        plate: String? = nil
    ) {
        self.uuid = uuid
        self.name = name
        self.brand = brand
        self.model = model
        self.mainFuelType = mainFuelType
        self.secondaryFuelType = secondaryFuelType
        self.initialOdometer = initialOdometer
        self.plate = plate
    }

    func saveToModelContext(context: ModelContext) throws {
        context.insert(self)
        try context.save()
        print("Vehicle \(name) saved successfully!")
    }

    static func mock() -> Vehicle {
        Vehicle(name: "Default car", brand: "Brand", model: "XYZ", initialOdometer: 0)
    }
}

extension Vehicle {
    func calculateTotalFuelExpenses(currency: Locale.Currency) -> String {
        let total = fuelExpenses.reduce(Decimal(0)) { $0 + $1.totalPrice.amount }
        return total.formatted(.currency(code: currency.identifier))
    }

    func calculateFuelEfficiency() -> Float? {
        guard fuelExpenses.count > 1 else { return nil }

        let sortedExpenses = fuelExpenses.sorted { $0.odometer < $1.odometer }
        var totalFuelConsumed: Float = 0
        var totalDistanceTraveled: Float = 0

        for i in 1 ..< sortedExpenses.count {
            let distance = sortedExpenses[i].odometer - sortedExpenses[i - 1].odometer
            if distance > 0 {
                totalDistanceTraveled += distance
                totalFuelConsumed += sortedExpenses[i].quantity
            }
        }

        guard totalDistanceTraveled > 0 else { return nil }
        return (totalFuelConsumed / totalDistanceTraveled) * 100
    }

    func isValidOdometer(_ odometer: Float, for designatedDate: Date) -> Bool {
        let sortedExpenses = fuelExpenses.sorted { $0.date < $1.date }

        guard !sortedExpenses.isEmpty else {
            return odometer > Float(initialOdometer)
        }

        if let firstExpense = sortedExpenses.first, designatedDate < firstExpense.date {
            return odometer <= firstExpense.odometer
        }

        if let lastExpense = sortedExpenses.last, designatedDate > lastExpense.date {
            guard odometer > Float(currentOdometer) else { return false }
        }

        guard let index = sortedExpenses.firstIndex(where: { $0.date >= designatedDate }) else {
            if let lastExpense = sortedExpenses.last, lastExpense.odometer > odometer {
                return false
            }
            return true
        }

        let closestBefore = index > 0 ? sortedExpenses[index - 1] : nil
        let closestAfter = index < sortedExpenses.count - 1 ? sortedExpenses[index + 1] : nil

        if let before = closestBefore, before.odometer > odometer { return false }
        if let after = closestAfter, after.odometer < odometer { return false }

        return true
    }
}
