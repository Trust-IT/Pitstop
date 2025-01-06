//
//  CoreDataManager.swift
//  Hurricane
//
//  Created by Asya Tealdi on 03/05/22.
//

import CoreData
import Foundation

class CoreDataManager {
    // Singleton
    static let instance = CoreDataManager()
    let container: NSPersistentContainer
    let context: NSManagedObjectContext

    init() {
        container = NSPersistentContainer(name: "CarModel")
        container.loadPersistentStores { _, error in
            if let error {
                print("Error loading Core Data: \(error)")
            }
        }
        context = container.viewContext
    }

    func save() {
        do {
            try context.save()
        } catch {
            print("Error saving Core Data. \(error.localizedDescription)")
        }
    }

    func removeAllItems(deleteRequest: NSBatchDeleteRequest) {
        do {
            try context.execute(deleteRequest)
        } catch let error as NSError {
            // TODO: handle the error
            print("Error when removing all Items:\(error.localizedDescription)")
        }
    }

    func getExpenseById(id: NSManagedObjectID) -> Expense? {
        do {
            return try context.existingObject(with: id) as? Expense
        } catch {
            print(error)
            return nil
        }
    }

    func deleteExpense(_ expense: Expense) {
        context.delete(expense)

        do {
            try context.save()
        } catch {
            context.rollback()
            print("Failed to delete expense \(error)")
        }
    }
}
