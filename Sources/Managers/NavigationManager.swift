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
    @Published var isPresented: Bool = false

    /// Pushes a new route onto the stack
    func push(_ route: Route) {
        if isPresented {
            modalRoutes.append(route)
        } else {
            routes.append(route)
        }
    }

    /// Sets a new route as the only route in the stack
    func set(_ route: Route) {
        if isPresented {
            modalRoutes = []
            presentedRoute = route
        } else {
            routes = []
            routes.append(route)
        }
    }

    /// Presents a new route modally
    func present(_ route: Route) {
        isPresented = true
        presentedRoute = route
        modalRoutes = []
    }

    /// Dismisses all presented routes
    func popAll() {
        if isPresented {
            modalRoutes = []
            isPresented = false
            presentedRoute = nil
        } else {
            routes = []
        }
    }

    /// Pops the top route from the stack
    func pop() {
        if isPresented, !modalRoutes.isEmpty {
            _ = modalRoutes.popLast()
        } else if isPresented, modalRoutes.isEmpty {
            isPresented = false
            presentedRoute = nil
        } else {
            _ = routes.popLast()
        }
    }
}

struct ModalNavigationContainerView: View {
    @EnvironmentObject var navManager: NavigationManager
    let route: Route

    var body: some View {
        NavigationStack(path: $navManager.modalRoutes) {
            VStack {
                route.body
            }
            .navigationDestination(for: Route.self) { route in
                route.body
            }
        }
    }
}
