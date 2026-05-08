//
//  OnboardingPageTemplate.swift
//  Pitstop-APP
//

import ChassisUI
import SwiftUI

struct OnboardingPageTemplate: View {
    let image: ChassisUIImages
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 40)
            VStack(spacing: 12) {
                Text(title)
                    .font(Typography.headerXL)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Palette.black)
                Text(subtitle)
                    .font(Typography.TextM)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Palette.black)
            }
            .padding(.horizontal, 24)
            Spacer()
            image.swiftUIImage
            Spacer()
        }
        .background(Palette.greyBackground)
    }
}
