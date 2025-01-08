//
//  CustomTabBarView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 06/05/22.
//

import SwiftUI

struct CustomTabBarView: View {
    @State var selectedIndex: Int = 0
    @StateObject var onboardingVM = OnboardingViewModel()

    var body: some View {
        CustomTabView(tabs: TabType.allCases.map(\.tabItem), selectedIndex: $selectedIndex) { index in
            let type = TabType(rawValue: index) ?? .home
            getTabView(type: type)
        }
    }

    @ViewBuilder
    func getTabView(type: TabType) -> some View {
        switch type {
        case .home:
            VehicleView(onboardingVM: onboardingVM)
        case .stats:
            AnalyticsView()
        case .settings:
            SettingsView(onboardingVM: onboardingVM)
        }
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBarView()
    }
}
