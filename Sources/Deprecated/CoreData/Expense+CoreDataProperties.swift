//
//  Expense+CoreDataProperties.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 05/05/22.
//
//

import CoreData
import Foundation

public extension Expense {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Expense> {
        NSFetchRequest<Expense>(entityName: "Expense")
    }

    @NSManaged var date: Date
    @NSManaged var note: String?
    @NSManaged var odometer: Float
    @NSManaged var price: Float
    @NSManaged var category: Int16
    @NSManaged var fuelType: Int16
    @NSManaged var liters: Float
    @NSManaged var priceLiter: Float
}

extension Expense: Identifiable {}
