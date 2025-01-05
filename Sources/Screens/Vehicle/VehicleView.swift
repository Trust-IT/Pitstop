//
//  VehicleView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 05/05/22.
//

import SwiftUI

struct VehicleView: View {
    @StateObject var onboardingVM: OnboardingViewModel
    @ObservedObject var dataVM: DataViewModel
    @ObservedObject var homeVM: HomeViewModel
    @ObservedObject var utilityVM: UtilityViewModel
    @ObservedObject var categoryVM: CategoryViewModel

    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var vehicleManager: VehicleManager

    @AppStorage("shouldShowOnboardings") var shouldShowOnboarding: Bool = true
//    @State var shouldShowOnboarding : Bool = true //FOR TESTING
    @State private var showAddReport = false

    var body: some View {
        GeometryReader { proxy in
            let topEdge = proxy.safeAreaInsets.top
            HomeStyleView(dataVM: dataVM, homeVM: homeVM, categoryVM: categoryVM, topEdge: topEdge)
                .ignoresSafeArea(.all, edges: .top)
        }
        .overlay(
            VStack {
                Spacer(minLength: UIScreen.main.bounds.size.height * 0.77)
                Button(action: {
                    showAddReport.toggle()
                }, label: {
                    HStack {
                        Spacer()
                        Image("plus")
                            .resizable()
                            .foregroundColor(Palette.white)
                            .frame(width: 14, height: 14)
                        Text("Add report")
                            .foregroundColor(Palette.white)
                            .font(Typography.ControlS)
                        Spacer()
                    }
                })
                .buttonStyle(Primary())
                Spacer()
            }
        )
        .ignoresSafeArea(.keyboard)
        .sheet(isPresented: $showAddReport) {
            AddReportView(utilityVM: utilityVM)
        }
        .fullScreenCover(
            isPresented: $shouldShowOnboarding,
            content: {
                OnboardingView(
                    onboardingVM: onboardingVM,
                    shouldShowOnboarding: $shouldShowOnboarding
                )
            }
        )
        .onAppear {
            if !shouldShowOnboarding {
                vehicleManager.loadCurrentVehicle(modelContext: modelContext)
            }
        }
    }
}

struct VehicleView_Previews: PreviewProvider {
    static var previews: some View {
        VehicleView(onboardingVM: OnboardingViewModel(), dataVM: DataViewModel(),
                    homeVM: HomeViewModel(), utilityVM: UtilityViewModel(),
                    categoryVM: CategoryViewModel())
    }
}
