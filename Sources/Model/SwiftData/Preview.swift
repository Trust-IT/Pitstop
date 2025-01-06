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
            modelContainer = try ModelContainer(for: Vehicle2.self, configurations: config)
        } catch {
            fatalError("Could not initialize ModelContainer")
        }
    }

    func addVehicle(_ vehicle: Vehicle2) {
        Task { @MainActor in
            modelContainer.mainContext.insert(vehicle)
        }
    }
}
