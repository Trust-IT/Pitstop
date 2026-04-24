//
//  FuelExpense.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 02/01/25.
//

import Foundation
import OSLog
import SwiftData

@Model
class FuelExpense: Identifiable {
    var uuid: UUID

    var totalCost: Decimal
    var quantity: Float
    var odometer: Int
    var fuelType: FuelType
    var date: Date
    var vehicle: Vehicle?

    /// Derived from `totalCost / quantity`. Not stored — always in sync with inputs.
    var pricePerUnit: Decimal {
        guard quantity > 0, totalCost > 0 else { return 0 }
        return totalCost / Decimal(Double(quantity))
    }

    init(
        uuid: UUID = UUID(),
        totalCost: Decimal,
        quantity: Float,
        odometer: Int,
        fuelType: FuelType,
        date: Date,
        vehicle: Vehicle?
    ) {
        self.uuid = uuid
        self.totalCost = totalCost
        self.quantity = quantity
        self.odometer = odometer
        self.fuelType = fuelType
        self.date = date
        self.vehicle = vehicle
    }

    static func mock() -> FuelExpense {
        .init(
            totalCost: 0,
            quantity: 0,
            odometer: 0,
            fuelType: .diesel,
            date: .now,
            vehicle: nil
        )
    }

    // MARK: CRUD

    func insert(context: ModelContext) {
        context.insert(self)
        save(context: context)
    }

    func save(context: ModelContext) {
        let cost = totalCost
        let name = vehicle?.name ?? "unknown"
        do {
            try context.save()
            Logger.persistence.debug("FuelExpense \(cost) for \(name) saved successfully")
        } catch {
            Logger.persistence.error("Error saving FuelExpense \(cost) for \(name): \(error)")
        }
    }

    func delete(context: ModelContext) {
        context.delete(self)
    }
}
