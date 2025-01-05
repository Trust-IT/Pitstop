//
//  CustomTabBarView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 06/05/22.
//

import SwiftUI

struct CustomTabBarView: View {
    @State var selectedIndex: Int = 0
    @StateObject var dataVM = DataViewModel()
    @StateObject var homeVM = HomeViewModel()
    @StateObject var utilityVM: UtilityViewModel = .init()
    @StateObject var categoryVM = CategoryViewModel()
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
            VehicleView(onboardingVM: onboardingVM, dataVM: dataVM, homeVM: homeVM, utilityVM: utilityVM, categoryVM: categoryVM)
        case .stats:
            AnalyticsOverviewView(dataVM: dataVM, categoryVM: categoryVM, utilityVM: utilityVM)
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
