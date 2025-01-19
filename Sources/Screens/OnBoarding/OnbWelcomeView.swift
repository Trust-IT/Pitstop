//
//  OnbWelcomeView.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 13/01/25.
//

import SwiftUI

struct OnbWelcomeView: View {
    @EnvironmentObject private var navManager: NavigationManager

    var body: some View {
        VStack(alignment: .center) {
            Spacer(minLength: 60)
            VStack(spacing: 12) {
                Text("Warm up your engine")
                    .font(Typography.headerXL)
                    .foregroundColor(Palette.black)
                Text("Gear up for a simple way of managing your \nvehicle and cutting costs")
                    .font(Typography.TextM)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Palette.black)
            }
            Spacer()
            Image(.page1)
            Spacer()
            Button(action: {
                withAnimation(.easeInOut) {
                    navManager.push(.onboardingRegistration)
                }
            }, label: {
                Text("Add a new vehicle")
            })
            .buttonStyle(Primary())
            .padding(.bottom, 32)
        }
        .background(Palette.greyBackground)
    }
}

#Preview {
    OnbWelcomeView()
        .environmentObject(NavigationManager())
}

enum VehicleInfoFocusField: Hashable {
    case vehicleName
    case brand
    case model
    case fuelType
    case plate
}
