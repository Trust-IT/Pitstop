//
//  AnalyticsEmptyView.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 24/04/26.
//

import SwiftUI

struct AnalyticsEmptyView: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(.page5)
                .resizable()
                .scaledToFit()
                .frame(width: 260)
            Text(title)
                .foregroundStyle(Palette.black)
                .font(Typography.headerM)
            Text(subtitle)
                .foregroundStyle(Palette.greyMiddle)
                .multilineTextAlignment(.center)
                .font(Typography.TextM)
            Spacer()
        }
        .padding(.horizontal, 32)
        .frame(maxWidth: .infinity)
        .background(Palette.greyBackground)
    }
}

#Preview {
    AnalyticsEmptyView(
        title: "No data yet",
        subtitle: "Add your first fuel expense to see analytics"
    )
    .environment(AppState())
}
