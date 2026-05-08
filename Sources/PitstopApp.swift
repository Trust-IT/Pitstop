//
//  PitstopApp.swift
//  Hurricane
//
//  Created by Asya Tealdi on 03/05/22.
//

import NavigatorUI
import PitstopData
import SwiftData
import SwiftUI

@main
struct PitstopApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @State private var vehicleManager: VehicleManager
    @State private var appState = AppState()
    let navigator = Navigator(configuration: .init(verbosity: .info))
    let modelContainer: ModelContainer

    init() {
        let schema = Schema([
            Document.self,
            Reminder.self,
            Vehicle.self,
            Number.self,
            FuelExpense.self
        ])

        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        let container: ModelContainer
        do {
            container = try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not find : \(error.localizedDescription)")
        }
        modelContainer = container
        _vehicleManager = State(initialValue: VehicleManager(modelContext: container.mainContext))
    }

    var body: some Scene {
        WindowGroup {
            EntryPointView()
                .modelContainer(modelContainer)
                .environment(vehicleManager)
                .environment(appState)
                .navigationRoot(navigator)
        }
    }
}
