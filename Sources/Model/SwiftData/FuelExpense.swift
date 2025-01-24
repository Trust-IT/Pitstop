//
//  FuelExpense.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 02/01/25.
//

import Foundation
import SwiftData

@Model
class FuelExpense: Identifiable {
    @Attribute(.unique)
    var uuid: UUID

    var totalPrice: Money
    var quantity: Float
    var pricePerUnit: Float
    var odometer: Float
    var fuelType: FuelType
    var date: Date

    init(
        uuid: UUID = UUID(),
        totalPrice: Money,
        quantity: Float,
        pricePerUnit: Float,
        odometer: Float,
        fuelType: FuelType,
        date: Date,
        vehicle: Vehicle?
    ) {
        self.uuid = uuid
        self.totalPrice = totalPrice
        self.quantity = quantity
        self.pricePerUnit = pricePerUnit
        self.odometer = odometer
        self.fuelType = fuelType
        self.date = date
        self.vehicle = vehicle
    }

    var vehicle: Vehicle?

    static func mock() -> FuelExpense {
        .init(totalPrice: .init(value: 0.0), quantity: 0, pricePerUnit: 0, odometer: 0, fuelType: .diesel, date: .now, vehicle: nil)
    }
    
    static func initialState() -> FuelExpense {
        .init(totalPrice: .init(value: 0.0), quantity: 0, pricePerUnit: 0, odometer: 0, fuelType: .diesel, date: .now, vehicle: nil)
    }

    // MARK: CRUD

    /// When inserting It calcultates the price per unit of fuel automatically
    func insert(context: ModelContext) {
        calculatePricePerUnit()
        context.insert(self)
        save(context: context)
    }

    func save(context: ModelContext) {
        do {
            try context.save()
            print("Fuel Expense \(totalPrice) for \(String(describing: vehicle?.name)) saved successfully!")
        } catch {
            print("Error saving fuel \(totalPrice) for \(String(describing: vehicle?.name)): \(error)")
        }
    }

    func delete(context: ModelContext) {
        context.delete(self)
    }
}

extension FuelExpense {
    
    func calculatePricePerUnit() {
        guard quantity > 0 else {
            pricePerUnit = 0
            return
        }
        if totalPrice.amount > 0 {
            pricePerUnit = (totalPrice.amount.floatValue / quantity).rounded(toPlaces: 2)
        }
    }
    
    /// Checks if the odometer value is valid for the current fuel expense
    /// - Parameter vehicle: The vehicle to check the odometer value against
    /// - Returns: A boolean indicating if the odometer value is valid
    func isValidOdometer(for vehicle: Vehicle) -> Bool {
        let sortedExpenses = vehicle.fuelExpenses.sorted { $0.date < $1.date }

        guard sortedExpenses.count > 0 else {
            return true // No previous expenses, so the odometer value is valid
        }

        // Binary search for the current fuel expense date
        guard let index = sortedExpenses.firstIndex(where: { $0.date >= self.date }) else {
            if let lastExpense = sortedExpenses.last, lastExpense.odometer > self.odometer {
                return false
            }
            return true
        }

        let closestBefore = index > 0 ? sortedExpenses[index - 1] : nil
        let closestAfter = index < sortedExpenses.count - 1 ? sortedExpenses[index + 1] : nil

        // Check if the odometer value is not lower than the previous
        if let before = closestBefore, before.odometer > self.odometer {
            return false
        }

        // Check if the odometer value is not higher than the next
        if let after = closestAfter, after.odometer < self.odometer {
            return false
        }

        return true
    }
}
