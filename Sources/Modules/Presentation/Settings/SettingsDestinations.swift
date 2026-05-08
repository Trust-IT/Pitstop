//
//  SettingsDestinations.swift
//  Pitstop
//
//  Created by Ivan Voloshchuk on 29/04/25.
//

import NavigatorUI
import PitstopData
import SwiftUI

enum SettingsDestinations {
    case editVehicle(input: Vehicle)
    case tos
    case aboutUs
}

extension SettingsDestinations: NavigationDestination {
    var body: some View {
        switch self {
        case let .editVehicle(vehicle):
            EditVehicleView(vehicle: vehicle)
        case .tos:
            HTMLView(htmlFileName: "TermsOfService")
        case .aboutUs:
            AboutView()
        }
    }
}

extension SettingsDestinations: Hashable {
    func hash(into hasher: inout Hasher) {
        switch self {
        case let .editVehicle(vehicle):
            hasher.combine(0)
            hasher.combine(vehicle.persistentModelID)
        case .tos:
            hasher.combine(1)
        case .aboutUs:
            hasher.combine(2)
        }
    }
}
