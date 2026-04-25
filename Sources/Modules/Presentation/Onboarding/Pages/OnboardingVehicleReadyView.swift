//
//  OnboardingVehicleReadyView.swift
//  Pitstop-APP
//

import SwiftUI

struct OnboardingVehicleReadyView: View {
    var body: some View {
        OnboardingPageTemplate(
            image: .page5,
            title: PitstopStrings.Localizable.Onb.vehicleReady,
            subtitle: PitstopStrings.Localizable.Onb.startEngine
        )
    }
}

#Preview {
    OnboardingVehicleReadyView()
}
