//
//  OnboardingNotificationPermissionView.swift
//  Pitstop-APP
//

import SwiftUI

struct OnboardingNotificationPermissionView: View {
    var body: some View {
        OnboardingPageTemplate(
            image: .page4,
            title: PitstopStrings.Localizable.Onb.dontMiss,
            subtitle: PitstopStrings.Localizable.Onb.reminderInfo
        )
    }
}

#Preview {
    OnboardingNotificationPermissionView()
}
