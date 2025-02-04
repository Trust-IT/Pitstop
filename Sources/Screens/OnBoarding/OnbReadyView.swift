//
//  OnbReadyView.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 17/01/25.
//

import SwiftUI

struct OnbReadyView: View {
    @EnvironmentObject private var navManager: NavigationManager
    @AppStorage("shouldShowOnboarding") var shouldShowOnboarding: Bool = true

    var body: some View {
        VStack(alignment: .center) {
            Image(.page5)
                .padding(.top, 78)
            Spacer()
            VStack(spacing: 12) {
                Text(PitstopAPPStrings.Onb.vehicleReady)
                    .font(Typography.headerXL)
                    .foregroundColor(Palette.black)
                Text(PitstopAPPStrings.Onb.startEngine)
                    .font(Typography.TextM)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Palette.black)
            }
            Spacer()
            Button(action: {
                navManager.popAll()
                shouldShowOnboarding = false
            }, label: {
                Text(PitstopAPPStrings.Onb.okLetsGo)
            })
            .buttonStyle(Primary())
            .padding(.bottom, 32)
            .navigationBarBackButtonHidden()
        }
        .background(Palette.greyBackground)
    }
}

#Preview {
    OnbReadyView()
        .environmentObject(NavigationManager())
}
