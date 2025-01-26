//
//  Vehicle.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 27/12/24.
//

import Foundation
import SwiftData

@Model
final class Vehicle: Identifiable {
    @Attribute(.unique)
    var uuid: UUID

    var name: String
    var brand: String
    var model: String
    var mainFuelType: FuelType
    var secondaryFuelType: FuelType?
    var odometer: Float
    var plate: String?

    @Relationship(deleteRule: .cascade, inverse: \Number.vehicle)
    var numbers: [Number] = []

    @Relationship(deleteRule: .cascade, inverse: \FuelExpense.vehicle)
    var fuelExpenses: [FuelExpense] = []

    var sortedFuelExpenses: [FuelExpense] {
        fuelExpenses.sorted { $0.date > $1.date }
    }

    init(
        uuid: UUID = UUID(),
        name: String,
        brand: String,
        model: String,
        mainFuelType: FuelType = .gasoline,
        secondaryFuelType: FuelType? = nil,
        odometer: Float,
        plate: String? = nil
    ) {
        self.uuid = uuid
        self.name = name
        self.brand = brand
        self.model = model
        self.mainFuelType = mainFuelType
        self.secondaryFuelType = secondaryFuelType
        self.odometer = odometer
        self.plate = plate
    }

    // Custom decode method to handle relationships
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uuid = try container.decode(UUID.self, forKey: .uuid)
        name = try container.decode(String.self, forKey: .name)
        brand = try container.decode(String.self, forKey: .brand)
        model = try container.decode(String.self, forKey: .model)
        mainFuelType = try container.decode(FuelType.self, forKey: .mainFuelType)
        secondaryFuelType = try container.decodeIfPresent(FuelType.self, forKey: .secondaryFuelType)
        odometer = try container.decode(Float.self, forKey: .odometer)
        plate = try container.decodeIfPresent(String.self, forKey: .plate)
    }

    func saveToModelContext(context: ModelContext) throws {
        context.insert(self)
        try context.save()
        print("Vehicle \(name) saved successfully!")
    }

    static func mock() -> Vehicle {
        Vehicle(name: "Default car", brand: "Brand", model: "XYZ", odometer: 0.0)
    }
}

extension Vehicle {
    func calculateTotalFuelExpenses() -> String {
        let total = fuelExpenses.reduce(0.0) { $0 + $1.totalPrice.amount }
        return total.description
    }

    func calculateFuelEfficiency() -> Float? {
        guard fuelExpenses.count > 1 else {
            return nil // Not enough data to calculate efficiency
        }

        // Sort fuel expenses by odometer reading
        let sortedExpenses = fuelExpenses.sorted { $0.odometer < $1.odometer }

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

        guard totalDistanceTraveled > 0 else { return nil }

        // Calculate efficiency
        // Total Fuel Consumed (Liters) / Total Distance Traveled (Kilometers) * 100
        return (totalFuelConsumed / totalDistanceTraveled) * 100
    }

    /// Checks if the odometer value is valid
    /// - Parameters: odometer: The odometer value to check
    /// - Parameters: designatedDate: The date for which the odometer value is being checked
    /// - Returns: A boolean indicating if the odometer value is valid
    func isValidOdometer(_ odometer: Float, for designatedDate: Date) -> Bool {
        let sortedExpenses = fuelExpenses.sorted { $0.date < $1.date }

        guard sortedExpenses.count > 0 else {
            // No previous expenses, so the value is valid only if it's higher than the current odometer
            return odometer > self.odometer
        }

        // Check if the designated date is before the first expense's date
        if let firstExpense = sortedExpenses.first, designatedDate < firstExpense.date {
            // Odometer is valid only if it is not greater than the first recorded odometer
            return odometer <= firstExpense.odometer
        }

        // Check the last recorded expense
        if let lastExpense = sortedExpenses.last, designatedDate > lastExpense.date {
            // Ensure the odometer value is greater than the vehicle's current odometer
            guard odometer > self.odometer else {
                return false
            }
        }

        // Binary search for the current fuel expense date
        guard let index = sortedExpenses.firstIndex(where: { $0.date >= designatedDate }) else {
            if let lastExpense = sortedExpenses.last, lastExpense.odometer > odometer {
                return false
            }
            return true
        }

        let closestBefore = index > 0 ? sortedExpenses[index - 1] : nil
        let closestAfter = index < sortedExpenses.count - 1 ? sortedExpenses[index + 1] : nil

        // Check if the odometer value is not lower than the previous
        if let before = closestBefore, before.odometer > odometer {
            return false
        }

        // Check if the odometer value is not higher than the next
        if let after = closestAfter, after.odometer < odometer {
            return false
        }

        return true
    }
}

extension Vehicle: Codable {
    enum CodingKeys: String, CodingKey {
        case uuid, name, brand, model, mainFuelType, secondaryFuelType, odometer, plate, year, expenses, numbers
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uuid, forKey: .uuid)
        try container.encode(name, forKey: .name)
        try container.encode(brand, forKey: .brand)
        try container.encode(model, forKey: .model)
        try container.encode(mainFuelType, forKey: .mainFuelType)
        try container.encode(secondaryFuelType, forKey: .secondaryFuelType)
        try container.encode(odometer, forKey: .odometer)
        try container.encode(plate, forKey: .plate)
    }
}
