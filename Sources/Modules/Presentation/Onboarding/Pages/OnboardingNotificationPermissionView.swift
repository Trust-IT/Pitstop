//
//  OnboardingNotificationPermissionView.swift
//  Pitstop-APP
//

import ChassisUI
import SwiftUI

struct OnboardingNotificationPermissionView: View {
    var body: some View {
        OnboardingPageTemplate(
            image: ChassisUIAsset.page4,
            title: PitstopStrings.Localizable.Onb.dontMiss,
            subtitle: PitstopStrings.Localizable.Onb.reminderInfo
        )
    }
}

#Preview {
    OnboardingNotificationPermissionView()
}
