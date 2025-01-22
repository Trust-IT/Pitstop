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
                Text("Don’t miss anything \nimportant")
                    .font(Typography.headerXL)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Palette.black)
                Text("Let us remind you key dates about your \nvehicle’s maintenance status and deadlines")
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
                    Text("Activate notifications")
                })
                .buttonStyle(Primary())
                Button(action: {
                    navManager.push(.onboardingReady)
                }, label: {
                    Text("Later")
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
