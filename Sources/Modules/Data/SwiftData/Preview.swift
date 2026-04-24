//
//  Preview.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 06/01/25.
//

import Foundation
import SwiftData

struct Preview {
    let modelContainer: ModelContainer
    init() {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        do {
            modelContainer = try ModelContainer(for: Vehicle.self, configurations: config)
        } catch {
            fatalError("Could not initialize ModelContainer")
        }
    }

    @MainActor
    func addVehicle(_ vehicle: Vehicle) {
        modelContainer.mainContext.insert(vehicle)
    }
}
