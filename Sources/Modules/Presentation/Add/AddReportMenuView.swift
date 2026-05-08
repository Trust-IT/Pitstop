//
//  AddReportMenuView.swift
//  Pitstop
//
//  Created by Ivan Voloshchuk on 25/01/25.
//

import ChassisUI
import NavigatorUI
import PitstopData
import SwiftUI

struct AddReportMenuView: View {
    @Environment(\.navigator) private var navigator
    @Binding var isPresented: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("What inspires you today?")
                .font(Typography.headerL)
                .foregroundStyle(Palette.black)
            Button(action: {
                isPresented.toggle()
                navigator.navigate(to: AddDestinations.fuelReport(input: .mock()))
            }, label: {
                HStack {
                    ZStack {
                        Circle()
                            .fill(Palette.colorYellow)
                            .frame(width: 34, height: 34)
                        ChassisUIAsset.fuel.swiftUIImage
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
                navigator.send(ShowReminderCreateEvent())
            }, label: {
                HStack {
                    ZStack {
                        Circle()
                            .fill(Palette.colorGreen)
                            .frame(width: 34, height: 34)
                        ChassisUIAsset.bell.swiftUIImage
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
                navigator.send(ShowAddVehicleEvent())
            }, label: {
                HStack {
                    ZStack {
                        Circle()
                            .fill(Palette.colorViolet)
                            .frame(width: 34, height: 34)
                        ChassisUIAsset.carSettings.swiftUIImage
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
        }
        .padding(.top, 40)
        .padding(.horizontal, 18)
        .background(Palette.greyBackground)
    }
}

#Preview {
    @Previewable @State var vehicleManager = PreviewSupport.vehicleManager
    AddReportMenuView(isPresented: .constant(true))
        .environment(vehicleManager)
}
