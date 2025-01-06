//
//  AlertsOnBoarding.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 19/05/22.
//

import SwiftUI

enum FocusFieldAlertOB: Hashable {
    case odometer
    case plate
}

struct AlertOdometerOB: View {
    @FocusState var focusedField: FocusFieldAlertOB?

    @Binding var vehicle: Vehicle
    @Binding var isPresented: Bool
    @Binding var showOverlay: Bool

    var body: some View {
        ZStack {
            Rectangle()
                .cornerRadius(18)
                .foregroundColor(Palette.white)
            VStack {
                HStack {
                    Spacer()
                    Text("Write the odometer")
                        .foregroundColor(Palette.black)
                        .font(Typography.headerM)
                        .padding(.leading, 40)
                    Spacer()
                    Button(action: {
                        isPresented.toggle()
                        showOverlay = false
                    }, label: {
                        buttonComponent(iconName: "ics")
                            .foregroundColor(Palette.black)
                            .padding(.trailing, 20)
                    })
                }
                VStack(spacing: 12) {
                    TextField(String(localized: "Previously 0 km"), value: $vehicle.odometer, formatter: NumberFormatter())
                        .disableAutocorrection(true)
                        .focused($focusedField, equals: .odometer)
                        .keyboardType(.numberPad)
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                        .frame(width: UIScreen.main.bounds.size.width * 0.84, height: UIScreen.main.bounds.size.height * 0.055)
                        .background(Palette.greyLight)
                        .font(Typography.TextM)
                        .foregroundColor(Palette.black)
                        .cornerRadius(36)
                        .overlay(
                            RoundedRectangle(cornerRadius: 36)
                                .stroke(focusedField == .plate ? Palette.black : Palette.greyInput, lineWidth: 1)
                        )

                    Button("Save") {
                        isPresented.toggle()
                        showOverlay = false
                    }
                    .buttonStyle(Primary())
                    .disabled(vehicle.odometer < 0)
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width * 0.92, height: UIScreen.main.bounds.height * 0.20)
        .onAppear { focusedField = .odometer }
    }

    @ViewBuilder
    func buttonComponent(iconName: String) -> some View {
        ZStack {
            Circle()
                .frame(width: 24, height: 24)
                .foregroundColor(Palette.greyLight)
            Image(iconName)
        }
    }
}

struct AlertPlateOB: View {
    @FocusState var focusedField: FocusFieldAlertOB?

    @State private var plateNumber: String = ""
    @Binding var vehicle: Vehicle
    @Binding var isPresented: Bool
    @Binding var showOverlay: Bool

    var body: some View {
        ZStack {
            Rectangle()
                .cornerRadius(18)
                .foregroundColor(Palette.white)
            VStack {
                HStack {
                    Spacer()
                    Text("Write the plate number")
                        .foregroundColor(Palette.black)
                        .font(Typography.headerM)
                        .padding(.leading, 40)
                    Spacer()
                    Button(action: {
                        isPresented.toggle()
                        showOverlay = false
                    }, label: {
                        buttonComponent(iconName: "ics")
                            .foregroundColor(Palette.black)
                            .padding(.trailing, 20)
                    })
                }
                VStack(spacing: 12) {
                    TextField("Plate number", text: $plateNumber)
                        .disableAutocorrection(true)
                        .focused($focusedField, equals: .plate)
                        .keyboardType(.default)
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                        .frame(width: UIScreen.main.bounds.size.width * 0.84, height: UIScreen.main.bounds.size.height * 0.055)
                        .background(Palette.greyLight)
                        .font(Typography.TextM)
                        .foregroundColor(Palette.black)
                        .cornerRadius(36)
                        .overlay(
                            RoundedRectangle(cornerRadius: 36)
                                .stroke(focusedField == .plate ? Palette.black : Palette.greyInput, lineWidth: 1)
                        )
                    Button("Save") {
                        isPresented.toggle()
                        showOverlay = false
                        vehicle.plate = plateNumber.isEmpty ? nil : plateNumber
                    }
                    .buttonStyle(Primary())
                    .disabled(plateNumber.isEmpty)
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width * 0.92, height: UIScreen.main.bounds.height * 0.20)
        .onAppear { focusedField = .plate }
    }

    @ViewBuilder
    func buttonComponent(iconName: String) -> some View {
        ZStack {
            Circle()
                .frame(width: 24, height: 24)
                .foregroundColor(Palette.greyLight)
            Image(iconName)
        }
    }
}
