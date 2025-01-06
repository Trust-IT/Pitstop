//
//  VehicleManager.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 28/12/24.
//

import Foundation
import SwiftData

class VehicleManager: ObservableObject {
    @Published private(set) var currentVehicle: Vehicle = .mock()

    private let userDefaultsKey = "currentVehicleUUID"

    func fetchVehicleByUUID(uuid: UUID, modelContext: ModelContext) -> Vehicle? {
        do {
            let descriptor = FetchDescriptor<Vehicle>(
                predicate: #Predicate { vehicle in
                    vehicle.uuid == uuid
                }
            )

            // Perform the fetch using the descriptor
            let vehicles = try modelContext.fetch(descriptor)
            return vehicles.first // Return the first matching vehicle, if any
        } catch {
            print("Error fetching vehicle by UUID: \(error)")
            return nil
        }
    }

    func loadCurrentVehicle(modelContext: ModelContext) {
        if let uuidString = UserDefaults.standard.string(forKey: userDefaultsKey),
           let uuid = UUID(uuidString: uuidString),
           let vehicle = fetchVehicleByUUID(uuid: uuid, modelContext: modelContext) {
            currentVehicle = vehicle
        }
    }

    func setCurrentVehicle(_ vehicle: Vehicle) {
        currentVehicle = vehicle
        saveUUIDToUserDefaults(vehicle: vehicle)
    }

    private func saveUUIDToUserDefaults(vehicle: Vehicle) {
        UserDefaults.standard.set(vehicle.uuid.uuidString, forKey: userDefaultsKey)
    }
}
