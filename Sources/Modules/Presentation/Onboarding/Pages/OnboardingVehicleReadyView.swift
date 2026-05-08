//
//  OnboardingVehicleReadyView.swift
//  Pitstop-APP
//

import ChassisUI
import PitstopData
import SwiftUI

struct OnboardingVehicleReadyView: View {
    var body: some View {
        OnboardingPageTemplate(
            image: ChassisUIAsset.page5,
            title: PitstopStrings.Localizable.Onb.vehicleReady,
            subtitle: PitstopStrings.Localizable.Onb.startEngine
        )
    }
}

#Preview {
    OnboardingVehicleReadyView()
}
