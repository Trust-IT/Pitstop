//
//  VehicleView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 05/05/22.
//

import NavigatorUI
import PitstopData
import SwiftUI

struct VehicleView: View {
    @Environment(AppState.self) var appState: AppState
    @Environment(VehicleManager.self) var vehicleManager: VehicleManager

    @AppStorage("shouldShowOnboarding") var shouldShowOnboarding: Bool = true

    var body: some View {
        ManagedNavigationStack(name: "Vehicle") { navigator in
            GeometryReader { proxy in
                let topEdge = proxy.safeAreaInsets.top
                HomeStyleView(topEdge: topEdge + 40, maxHeight: proxy.size.height / 3.8)
            }
            .navigationModifier { destination in
                destination()
                    .toolbar(.hidden, for: .tabBar)
                    .environment(appState)
                    .environment(vehicleManager)
            }
            .onAppear {
                if shouldShowOnboarding {
                    navigator.send(ShowOnboardingWelcomeEvent())
                } else {
                    vehicleManager.loadCurrentVehicle()
                }
            }
            .onNavigationReceive { (_: ShowReminderCreateEvent, nav) in
                nav.navigate(to: VehicleDestinations.reminderReport(input: .mock(), isEdit: false), method: .managedCover)
                return .auto
            }
        }
    }
}

#Preview {
    @Previewable @State var vehicleManager = PreviewSupport.vehicleManager
    VehicleView()
        .environment(vehicleManager)
        .environment(AppState())
}
