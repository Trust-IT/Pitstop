//
//  Preview.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 06/01/25.
//

import Foundation
import PitstopData
import SwiftData

@MainActor
enum PreviewSupport {
    static let modelContainer: ModelContainer = {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        do {
            return try ModelContainer(
                for: Vehicle.self, FuelExpense.self, Reminder.self, Document.self, Number.self,
                configurations: config
            )
        } catch {
            fatalError("Could not initialize preview ModelContainer: \(error)")
        }
    }()

    static var vehicleManager: VehicleManager {
        VehicleManager(modelContext: modelContainer.mainContext)
    }
}
