//
//  MainView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 05/05/22.
//

import SwiftUI

struct VehicleView: View {
    
    //Onboarding vars
    @AppStorage("shouldShowOnboarding") var shouldShowOnboarding : Bool = true
//    @State var shouldShowOnboarding : Bool = true //FOR TESTING
    @StateObject var onboardingVM = OnboardingViewModel()
    
    @State private var showAddReport = false
    
    
    var body: some View {
        GeometryReader{ proxy in
            let topEdge = proxy.safeAreaInsets.top
            
            HomeStyleView(topEdge: topEdge)
                .ignoresSafeArea(.all,edges: .top)
            
        }
        .overlay(
            VStack{
                Spacer(minLength: UIScreen.main.bounds.size.height * 0.77)
                Button(action: {
                    showAddReport.toggle()
                }, label: {
                    AddReportButton(text: "Add report")
                })
                Spacer()
            }
        )
        .sheet(isPresented: $showAddReport) {
                   AddReportView()
               }
//        .fullScreenCover(isPresented: $shouldShowOnboarding, content: {
//            OnboardingView(onboardingVM: onboardingVM, shouldShowOnboarding: $shouldShowOnboarding)
//        })

    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        VehicleView()
    }
}


struct AddReportButton : View {
    
    var text : String
    var body: some View {
        
        ZStack{
            Rectangle()
                .frame(width: UIScreen.main.bounds.size.width * 0.90, height: UIScreen.main.bounds.size.height * 0.055, alignment: .center)
                .cornerRadius(43)
                .foregroundColor(Palette.black)
            HStack{
                Spacer()
                Image("plus")
                    .resizable()
                    .frame(width: 14, height: 14)
                Text(text)
                    .foregroundColor(Palette.white)
                    .font(Typography.ControlS)
                Spacer()
            }
        }
    }
}


