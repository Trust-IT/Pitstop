//
//  VehicleView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 05/05/22.
//

import SwiftUI

struct VehicleView: View {
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var vehicleManager: VehicleManager
    @EnvironmentObject private var navManager: NavigationManager

    @AppStorage("shouldShowOnboardings") var shouldShowOnboarding: Bool = true
//    @State var shouldShowOnboarding : Bool = true //FOR TESTING
    @State private var showAddReport = false

    var body: some View {
        GeometryReader { proxy in
            let topEdge = proxy.safeAreaInsets.top
            HomeStyleView(topEdge: topEdge)
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
            AddReportView()
        }
        .fullScreenCover(isPresented: $navManager.isPresented) {
            if let presentedRoute = navManager.presentedRoute {
                ModalNavigationContainerView(route: presentedRoute)
            }
        }
        .onAppear {
            if shouldShowOnboarding {
                navManager.present(.onboardingWelcome)
            } else {
                vehicleManager.loadCurrentVehicle(modelContext: modelContext)
            }
        }
    }
}

struct VehicleView_Previews: PreviewProvider {
    static var previews: some View {
        VehicleView()
    }
}
