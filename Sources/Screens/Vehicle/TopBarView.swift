//
//  TopBarView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 26/05/22.
//

import SwiftData
import SwiftUI

struct TopNav: View {
    @EnvironmentObject var vehicleManager: VehicleManager
    @EnvironmentObject var navManager: NavigationManager

    @State private var showingAllCars = false

    var offset: CGFloat
    let maxHeight: CGFloat
    var topEdge: CGFloat

    var brandModelString: String {
        "\(vehicleManager.currentVehicle.brand) \(vehicleManager.currentVehicle.model)"
    }

    @Query
    var vehicles: [Vehicle]

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button(action: {
                    showingAllCars.toggle()
                }, label: {
                    HStack {
                        Text(vehicleManager.currentVehicle.name)
                            .foregroundColor(Palette.blackHeader)
                            .font(Typography.headerXL)
                            .opacity(fadeOutOpacity())
                        Image(.arrowLeft)
                            .resizable()
                            .foregroundColor(Palette.blackHeader)
                            .frame(width: 10, height: 14)
                            .rotationEffect(showingAllCars ? Angle(degrees: 180) : Angle(degrees: 270))
                    }
                    .padding(.leading, -1)
                    .opacity(fadeOutOpacity())
                })
                .disabled(fadeOutOpacity() < 0.35)
                .confirmationDialog(
                    String(localized: "Select a vehicle"),
                    isPresented: $showingAllCars,
                    titleVisibility: .hidden
                ) {
                    ForEach(vehicles, id: \.uuid) { vehicle in
                        Button(vehicle.name) {
                            vehicleManager.setCurrentVehicle(vehicle)
                        }
                    }
                    Button(PitstopAPPStrings.Common.cancel, role: .cancel) {}
                        .background(.black)
                        .foregroundColor(.red)
                }

                Spacer()
                HStack {
                    ZStack {
                        Button(action: {
                            navManager.push(.reminderList)
                        }, label: {
                            ZStack {
                                Circle()
                                    .foregroundColor(Palette.whiteHeader)
                                    .frame(width: UIScreen.main.bounds.width * 0.09, height: UIScreen.main.bounds.height * 0.04)
                                    .shadowGrey()
                                Image(.bellHome)
                            }
                        })
                    }
                }
                .padding(.top, 2)
            }
            Text(brandModelString)
                .foregroundColor(Palette.blackHeader)
                .font(Typography.TextM)
                .padding(.top, -12)
                .opacity(fadeOutOpacity())
        }
        .overlay(
            VStack(alignment: .center, spacing: 2) {
                Text(vehicleManager.currentVehicle.name)
                    .font(Typography.headerM)
                    .foregroundColor(Palette.blackHeader)
                Text(brandModelString)
                    .font(Typography.TextM)
                    .foregroundColor(Palette.blackHeader)
            }
            .opacity(
                withAnimation(.easeInOut) {
                    fadeInOpacity()
                })
            .padding(.bottom, 15)
        )
    }

    // Opacity to let appear items in the top bar
    func fadeInOpacity() -> CGFloat {
        // to start after the main content vanished
        // we nee to eliminate 70 from the offset
        // to get starter..
        let progress = -(offset + 70) / (maxHeight - (60 + topEdge * 3.2))

        return progress
    }

    // Opacity to let items in top bar disappear on scroll
    func fadeOutOpacity() -> CGFloat {
        // 70 = Some rnadom amount of time to visible on scroll
        let progress = -offset / 70
        let opacity = 1 - progress

        return offset < 0 ? opacity : 1
    }
}
