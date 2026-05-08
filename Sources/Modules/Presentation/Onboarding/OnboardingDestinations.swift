//
//  OnboardingDestinations.swift
//  Pitstop
//
//  Created by Ivan Voloshchuk on 29/04/25.
//

import NavigatorUI
import PitstopData
import SwiftUI

enum OnboardingDestinations: Hashable {
    case welcome
    case addVehicle
}

extension OnboardingDestinations: NavigationDestination {
    nonisolated var method: NavigationMethod { .managedCover }

    var body: some View {
        switch self {
        case .welcome:
            OnboardingFlowView(pages: [.welcome, .registration, .moreInfo, .notification, .ready])
        case .addVehicle:
            OnboardingFlowView(pages: [.welcome, .registration, .moreInfo, .ready], isDismissible: true)
        }
    }
}
