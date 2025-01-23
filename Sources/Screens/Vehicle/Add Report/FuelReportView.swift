//
//  FuelReportView.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 23/01/25.
//

import SwiftUI

struct FuelReportView: View {
    @FocusState private var focusState: FuelInputFocusField?
    @EnvironmentObject private var navManager: NavigationManager
    @State private var totalPrice = ""
    @State private var odometer = ""
    @State private var liters = ""
    var body: some View {
        ScrollView{
            VStack(spacing:14){
                ExtractedView(
                    title: "Total",
                    placeholder: "0.0",
                    measurement: "€",
                    icon: .category,
                    focusState: $focusState,
                    focus: .totalPrice,
                    text: $totalPrice
                )
                ExtractedView(
                    title: "Odometer",
                    placeholder: "Odometer",
                    measurement: "Km",
                    icon: .odometer,
                    focusState: $focusState,
                    focus: .odometer,
                    text: $odometer
                )
                ExtractedView(
                    title: "Liters",
                    placeholder: "Liters",
                    measurement: "L",
                    icon:.liters,
                    focusState: $focusState,
                    focus: .quantity,
                    text: $liters
                )
                Spacer()
                Button("Save") {
                    navManager.pop()
                }
                .buttonStyle(Primary())
                .padding(.bottom,12)
            }
        }
        .onTapGesture {
            focusState = nil
        }
        .onAppear {
            focusState = .totalPrice
        }
        .padding(.top,50)
        .background(Palette.greyBackground.ignoresSafeArea(.all))
        .navigationBarBackButtonHidden()
        .toolbar {
            if let focus = focusState {
                ToolbarItem(placement: .keyboard) {
                    Button(action: {
                        if focus == .totalPrice {
                            focusState = .odometer
                        } else if focus == .odometer {
                            focusState = .quantity
                        } else if focus == .quantity {
                            focusState = .totalPrice
                        }
                    }, label: {
//                        HStack {
//                            Spacer()
                            Text("Next")
                                .foregroundStyle(Palette.black)
                                .font(Typography.headerM)
//                        }
                    })
                }
            }
            ToolbarItem(placement: .navigation) {
                Button(action: {
                    navManager.pop()
                }, label: {
                    Image(.arrowLeft)
                        .resizable()
                        .frame(width: 12, height: 16)
                        .tint(Palette.black)
                })
            }
            ToolbarItemGroup(placement: .topBarTrailing) {
                HStack {
                  
                    Button(action: {
                    }, label: {
                        HStack {
                            Image(.fuelType)
                                .resizable()
                                .frame(width: 16, height: 16)
                                .tint(Palette.black)
                            Text("CNG (Methane)")
                                .fixedSize()
                        }
                        .padding(8)
                    })
                    .buttonStyle(SecondaryCapsule())
                    Button(action: {
                    }, label: {
                        HStack {
                            Image(.day)
                                .resizable()
                                .frame(width: 16, height: 16)
                                .tint(Palette.black)
                            Text("23.01.2025")
                                .fixedSize()
                        }
                        .padding(8)
                    })
                    .buttonStyle(SecondaryCapsule())
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var navManager = NavigationManager()
    NavigationStack(path: $navManager.routes) {
        FuelReportView()
            .environmentObject(VehicleManager())
            .environment(AppState())
            .environmentObject(NavigationManager())
    }
}

struct ExtractedView: View {
    let title: String
    let placeholder: String
    let measurement: String
    let icon: ImageResource
    @FocusState.Binding var focusState: FuelInputFocusField?
    let focus: FuelInputFocusField
    @Binding var text: String
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .foregroundStyle(Palette.black)
                .font(Typography.headerM)
                .padding(.horizontal,12)
            HStack {
                ZStack {
                    Circle()
                        .fill(Palette.colorViolet)
                        .frame(width: 32, height: 32)
                    Image(icon)
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(Palette.colorVioletIcon)
                }
                TextField(placeholder, text: $text)
                    .foregroundStyle(Palette.black)
                    .font(Typography.headerM)
                    .padding(.leading,12)
                    .keyboardType(.decimalPad)
                    .focused($focusState, equals: focus)
                //                .background(Color.yellow)
                //                .frame(width: 200,alignment: .trailing)
                Spacer()
                Text(measurement)
                    .foregroundStyle(Palette.black)
                    .font(Typography.headerM)
                //            Spacer()
                
            }
            .padding(.horizontal,12)
            .frame(height: 54)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Palette.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(focusState == focus ? Palette.black : Palette.white, lineWidth: 1)
                    )
            )
        }
        .padding(.horizontal,12)
        .background(Palette.greyBackground)
    }
}
