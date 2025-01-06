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

    var totalPrice: Float
    var quantity: Float
    var pricePerUnit: Float
    var odometer: Float
    var fuelType: FuelType
    var date: Date

    init(
        uuid: UUID = UUID(),
        totalPrice: Float,
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
        .init(totalPrice: 0, quantity: 0, pricePerUnit: 0, odometer: 0, fuelType: .diesel, date: .now, vehicle: nil)
    }

    // MARK: CRUD

    func insert(context: ModelContext) {
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
