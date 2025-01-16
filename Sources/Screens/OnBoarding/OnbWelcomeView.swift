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
        VStack {
            Button("Push") {
                navManager.push(.onboardingWelcome)
            }
            Button("Pop") {
                navManager.pop()
            }
            Button("PopALL") {
                navManager.popAll()
            }
        }
    }
}

#Preview {
    OnbWelcomeView()
}
