//
//  FuelExpense.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 02/01/25.
//

import Foundation
import OSLog
import SwiftData

private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.pitstop", category: "persistence")

@Model
public class FuelExpense: Identifiable {
    public var uuid: UUID

    public var totalCost: Decimal
    public var quantity: Float
    public var odometer: Int
    public var fuelType: FuelType
    public var date: Date
    public var vehicle: Vehicle?

    /// Derived from `totalCost / quantity`. Not stored — always in sync with inputs.
    public var pricePerUnit: Decimal {
        guard quantity > 0, totalCost > 0 else { return 0 }
        return totalCost / Decimal(Double(quantity))
    }

    public init(
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

    public static func mock() -> FuelExpense {
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

    public func insert(context: ModelContext) {
        context.insert(self)
        save(context: context)
    }

    public func save(context: ModelContext) {
        let cost = totalCost
        let name = vehicle?.displayName ?? "unknown"
        do {
            try context.save()
            logger.debug("FuelExpense \(cost) for \(name) saved successfully")
        } catch {
            logger.error("Error saving FuelExpense \(cost) for \(name): \(error)")
        }
    }

    public func delete(context: ModelContext) {
        context.delete(self)
    }
}
