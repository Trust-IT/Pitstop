//
//  EntryPointView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 06/05/22.
//

import SwiftUI

struct EntryPointView: View {
    @State var selectedIndex: Int = 0
    @StateObject var onboardingVM = OnboardingViewModel()

    var body: some View {
        TabView(selection: $selectedIndex) {
            VehicleView(onboardingVM: onboardingVM)
                .tabItem {
                    Label("Vehicle", image: .carIcon)
                }
                .tag(0)

            AnalyticsView()
                .tabItem {
                    Label("Analytics", image: .chartIcon)
                }
                .tag(1)

            SettingsView(onboardingVM: onboardingVM)
                .tabItem {
                    Label("Settings", image: .settingsIcon)
                }
                .tag(2)
        }
        .tint(Palette.black)
        .onAppear(perform: {
            UITabBar.appearance().unselectedItemTintColor = Palette.greyEBEBEB.uiColor
            UITabBarItem.appearance().badgeColor = Palette.black.uiColor
            UITabBar.appearance().backgroundColor = Palette.white.uiColor
        })
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        EntryPointView()
    }
}
