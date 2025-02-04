//
//  OnbNotificationView.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 17/01/25.
//

import SwiftUI

struct OnbNotificationView: View {
    @EnvironmentObject private var navManager: NavigationManager

    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            VStack(spacing: 12) {
                Text(PitstopAPPStrings.Onb.dontMiss)
                    .font(Typography.headerXL)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Palette.black)
                Text(PitstopAPPStrings.Onb.reminderInfo)
                    .font(Typography.TextM)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Palette.black)
            }
            .padding(.vertical, -70)
            Spacer()
            Image(.page4)
                .offset(y: -20)
            Spacer()
            VStack(spacing: 16) {
                Button(action: {
                    Task {
                        do {
                            _ = try await NotificationManager.shared.requestAuthNotifications()
                        } catch {
                            print("Error requesting notifications: \(error)")
                        }
                    }
                    navManager.push(.onboardingReady)
                }, label: {
                    Text(PitstopAPPStrings.Onb.activateNotifications)
                })
                .buttonStyle(Primary())
                Button(action: {
                    navManager.push(.onboardingReady)
                }, label: {
                    Text(PitstopAPPStrings.Onb.later)
                })
                .buttonStyle(Secondary())
            }
        }
        .background(Palette.greyBackground)
    }
}

#Preview {
    OnbNotificationView()
        .environmentObject(NavigationManager())
}
