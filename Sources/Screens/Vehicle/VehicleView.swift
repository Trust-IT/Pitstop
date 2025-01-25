//
//  VehicleView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 05/05/22.
//

import SwiftUI

struct VehicleView: View {
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var vehicleManager: VehicleManager
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
                    .toolbar(.hidden, for: .tabBar)
            }
            .fullScreenCover(isPresented: $navManager.isPresented) {
                if let presentedRoute = navManager.presentedRoute {
                    ModalNavigationContainerView(route: presentedRoute)
                }
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
            .environmentObject(VehicleManager())
            .environmentObject(NavigationManager())
            .environment(AppState())
            .environment(SceneDelegate())
    }
}
