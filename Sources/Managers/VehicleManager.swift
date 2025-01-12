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
    @Published var monthlyFuelEfficency: [String: Float] = [:]

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

    func getMonthlyFuelEfficency() {
        guard currentVehicle.fuelExpenses.count > 1 else {
            return
        }

        // Group fuel expenses by month and year
        let groupedByMonth = Dictionary(grouping: currentVehicle.fuelExpenses) { expense -> String in
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM"
            return formatter.string(from: expense.date)
        }

        for (month, expenses) in groupedByMonth {
            let sortedExpenses = expenses.sorted { $0.odometer < $1.odometer }

            var totalFuelConsumed: Float = 0
            var totalDistanceTraveled: Float = 0

            for i in 1 ..< sortedExpenses.count {
                let previousExpense = sortedExpenses[i - 1]
                let currentExpense = sortedExpenses[i]

                // Calculate the distance traveled
                let distance = currentExpense.odometer - previousExpense.odometer
                if distance > 0 {
                    totalDistanceTraveled += distance
                    totalFuelConsumed += currentExpense.quantity
                }
            }

            // Check if we can calculate efficiency for this month
            guard totalDistanceTraveled > 0 else { continue }

            let efficiency = (totalFuelConsumed / totalDistanceTraveled) * 100
            monthlyFuelEfficency[month] = efficiency
        }
    }

    private func saveUUIDToUserDefaults(vehicle: Vehicle) {
        UserDefaults.standard.set(vehicle.uuid.uuidString, forKey: userDefaultsKey)
    }
}

// TODO: Implement
struct MonthlyFuelData {
    var totalCost: Float
    var averageCost: Float
    var refuelsAmount: Int
    var daysFromLastRefuel: Int
}
