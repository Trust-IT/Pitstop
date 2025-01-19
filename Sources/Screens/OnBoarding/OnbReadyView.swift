//
//  OnbReadyView.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 17/01/25.
//

import SwiftUI

struct OnbReadyView: View {
    @EnvironmentObject private var navManager: NavigationManager

    var body: some View {
        VStack(alignment: .center) {
            Image(.page5)
                .padding(.top, 78)
            Spacer()
            VStack(spacing: 12) {
                Text("Your vehicle is ready!")
                    .font(Typography.headerXL)
                    .foregroundColor(Palette.black)
                Text("You are set to start your engine and optimize \n your spendings")
                    .font(Typography.TextM)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Palette.black)
            }
            Spacer()
            Button(action: {
                navManager.popAll()
            }, label: {
                Text("Okayyyy let's go")
            })
            .buttonStyle(Primary())
            .padding(.bottom, 32)
            .navigationBarBackButtonHidden()
        }
        .background(Palette.greyBackground)
    }
}

#Preview {
    OnbReadyView()
        .environmentObject(NavigationManager())
}
