//
//  AddReportMenuView.swift
//  Pitstop
//
//  Created by Ivan Voloshchuk on 25/01/25.
//

import SwiftUI

struct AddReportMenuView: View {
    @Environment(AppState.self) var appState: AppState
    @EnvironmentObject private var navManager: NavigationManager
    @Binding var isPresented: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("What inspires you today?")
                .font(Typography.headerL)
                .foregroundStyle(Palette.black)
            Button(action: {
                isPresented.toggle()
                navManager.push(.fuelReport(input: .initialState()))
            }, label: {
                HStack {
                    ZStack {
                        Circle()
                            .fill(Palette.colorYellow)
                            .frame(width: 34, height: 34)
                        Image(.fuel)
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(Palette.yellowAccent)
                    }
                    VStack(alignment: .leading) {
                        Text("Fuel")
                            .font(Typography.headerMS)
                            .foregroundStyle(Palette.black)

                        Text("Create a fuel entry")
                            .font(Typography.TextM)
                            .foregroundStyle(Palette.greyMiddle)
                    }
                    Spacer()
                }
            })
            Button(action: {
                isPresented.toggle()
                navManager.push(.reminderReport)
            }, label: {
                HStack {
                    ZStack {
                        Circle()
                            .fill(Palette.colorGreen)
                            .frame(width: 34, height: 34)
                        Image(.bell)
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(Palette.greenAccent)
                    }
                    VStack(alignment: .leading) {
                        Text("Reminder")
                            .font(Typography.headerMS)
                            .foregroundStyle(Palette.black)

                        Text("Set a notification reminder")
                            .font(Typography.TextM)
                            .foregroundStyle(Palette.greyMiddle)
                    }
                    Spacer()
                }
            })
            Button(action: {
                isPresented.toggle()
                navManager.push(.onboardingRegistration)
                appState.setAddingNewVehicle(true)
            }, label: {
                HStack {
                    ZStack {
                        Circle()
                            .fill(Palette.colorViolet)
                            .frame(width: 34, height: 34)
                        Image(.carSettings)
                            .resizable()
                            .frame(width: 18, height: 18)
                            .foregroundStyle(Palette.violetAccent)
                    }
                    VStack(alignment: .leading) {
                        Text("Vehicle")
                            .font(Typography.headerMS)
                            .foregroundStyle(Palette.black)

                        Text("Add a new vehicle to your collection")
                            .font(Typography.TextM)
                            .foregroundStyle(Palette.greyMiddle)
                    }
                    Spacer()
                }
            })
            Spacer()
        }
        .padding(.top, 40)
        .padding(.horizontal, 18)
        .background(Palette.greyBackground)
    }
}

#Preview {
    AddReportMenuView(isPresented: .constant(true))
        .environmentObject(NavigationManager())
        .environmentObject(VehicleManager())
        .environment(AppState())
        .environment(SceneDelegate())
}
