//
//  NavigationManager.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 13/01/25.
//

import Foundation
import SwiftUI

class NavigationManager: ObservableObject {
    @Published var routes = [Route]()
    @Published var modalRoutes = [Route]()
    @Published var presentedRoute: Route?
    @Published var selectedTab: TabBarItem = .vehicle

    var isInModal: Bool { presentedRoute != nil }

    func push(_ route: Route) {
        if isInModal {
            modalRoutes.append(route)
        } else {
            routes.append(route)
        }
    }

    func present(_ route: Route) {
        presentedRoute = route
        modalRoutes = []
    }

    func popAll() {
        if isInModal {
            modalRoutes = []
            presentedRoute = nil
        } else {
            routes = []
        }
    }

    func pop() {
        if isInModal, !modalRoutes.isEmpty {
            modalRoutes.removeLast()
        } else if isInModal {
            presentedRoute = nil
        } else {
            routes.removeLast()
        }
    }
}

struct ModalNavigationContainerView: View {
    @EnvironmentObject var navManager: NavigationManager
    @Environment(VehicleManager.self) var vehicleManager: VehicleManager
    @Environment(AppState.self) var appState: AppState
    let route: Route

    var body: some View {
        NavigationStack(path: $navManager.modalRoutes) {
            VStack {
                route
            }
            .navigationDestination(for: Route.self) { route in
                route
                    .environment(appState)
                    .environment(vehicleManager)
            }
        }
    }
}
