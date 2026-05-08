//
//  OnboardingWelcomeView.swift
//  Pitstop-APP
//

import ChassisUI
import SwiftUI

struct OnboardingWelcomeView: View {
    var body: some View {
        OnboardingPageTemplate(
            image: ChassisUIAsset.page1,
            title: PitstopStrings.Localizable.Onb.warmUpEngine,
            subtitle: PitstopStrings.Localizable.Onb.gearUp
        )
    }
}

#Preview {
    OnboardingWelcomeView()
}
