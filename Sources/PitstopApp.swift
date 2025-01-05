//
//  PitstopApp.swift
//  Hurricane
//
//  Created by Asya Tealdi on 03/05/22.
//

import SwiftData
import SwiftUI

@main
struct PitstopApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @StateObject var vehicleManager = VehicleManager()
    @StateObject var utilityVM = UtilityViewModel()
    let modelContainer: ModelContainer

    init() {
        let schema = Schema([
            Document.self,
            Reminder.self,
            Vehicle2.self,
            Expense2.self,
            Number.self,
            FuelExpense.self,
        ])

        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

        do {
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not find : \(error.localizedDescription)")
        }
    }

    var body: some Scene {
        WindowGroup {
            CustomTabBarView()
                .modelContainer(modelContainer)
                .environmentObject(vehicleManager)
                .environmentObject(utilityVM)
//            ContentView()
//            AnalyticsOverviewView()
        }
    }
}
