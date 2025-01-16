//
//  Route.swift
//  Pitstop
//
//  Created by Ivan Voloshchuk on 16/01/25.
//

import SwiftUI

enum Route {
    // Onboarding
    case onboardingWelcome
    case onboardingRegistration
    case onboardingMoreInfo
    case onboardingNotification
    case onboardingReady
    
    // Vehicle
    case addNewReport
}

extension Route: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(hashValue)
    }
}

extension Route: View {
    var body: some View {
        switch self {
        case .onboardingWelcome:
            OnbWelcomeView()
        case .onboardingRegistration:
            OnbRegistrationView()
        case .addNewReport:
            AddReportView()
        default:
            EmptyView()
        }
    }
}
