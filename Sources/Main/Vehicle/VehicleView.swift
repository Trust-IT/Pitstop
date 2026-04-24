//
//  VehicleView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 05/05/22.
//

import SwiftUI

struct VehicleView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(AppState.self) var appState: AppState
    @Environment(VehicleManager.self) var vehicleManager: VehicleManager
    @EnvironmentObject private var navManager: NavigationManager

    @AppStorage("shouldShowOnboarding") var shouldShowOnboarding: Bool = true
    @State private var showAddReport = false
    @State private var showingAdd = false

    var body: some View {
        NavigationStack(path: $navManager.routes) {
            GeometryReader { proxy in
                let topEdge = proxy.safeAreaInsets.top
                HomeStyleView(topEdge: topEdge + 40)
            }
            .navigationDestination(for: Route.self) { route in
                route
                    .environment(appState)
                    .environment(vehicleManager)
                    .toolbar(.hidden, for: .tabBar)
            }
            .fullScreenCover(item: $navManager.presentedRoute) { presentedRoute in
                ModalNavigationContainerView(route: presentedRoute)
                    .environment(appState)
                    .environment(vehicleManager)
                    .environmentObject(navManager)
            }
            .onAppear {
                if shouldShowOnboarding {
                    navManager.present(.onboardingWelcome)
                } else {
                    vehicleManager.loadCurrentVehicle(modelContext: modelContext)
                }
            }
        }
    }
}

struct VehicleView_Previews: PreviewProvider {
    static var previews: some View {
        VehicleView()
            .environment(VehicleManager())
            .environmentObject(NavigationManager())
            .environment(AppState())
            .environment(SceneDelegate())
    }
}
