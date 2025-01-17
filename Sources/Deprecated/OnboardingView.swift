//
//  OnboardingView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 09/05/22.
//

import SwiftUI
import UserNotifications

struct OnboardingView: View {
    @StateObject var onboardingVM: OnboardingViewModel
    @State private var destination: Pages = .page1
    @Binding var shouldShowOnboarding: Bool

    var body: some View {
        switch onboardingVM.destination {
        case .page1:
            withAnimation(.easeOut) {
                Page1(onboardingVM: onboardingVM)
            }

        case .page2:
            withAnimation(.easeOut(duration: 0.2)) {
                Page2(onboardingVM: onboardingVM)
            }
        case let .page3(vehicle):
            Page3(onboardingVM: onboardingVM, vehicle: vehicle)
        case .page4:
            withAnimation(.easeInOut(duration: 0.2)) {
                Page4(onboardingVM: onboardingVM)
            }
        case .page5:
            Page5(shouldShowOnboarding: $shouldShowOnboarding, onboardingVM: onboardingVM)
        }
    }
}
