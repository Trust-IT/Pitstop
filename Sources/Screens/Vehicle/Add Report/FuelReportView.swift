//
//  FuelReportView.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 23/01/25.
//

import SwiftUI

struct FuelReportView: View {
    @FocusState private var focusState: FuelInputFocusField?
    @Environment(AppState.self) var appState: AppState
    @EnvironmentObject private var navManager: NavigationManager
    @State private var totalPrice = ""
    @State private var odometer = ""
    @State private var liters = ""
    @State private var fuelType: FuelType = .diesel
    @State private var secondaryFuelType: FuelType? = .gasoline
    @State private var selectedDate = Date()
    @State private var alert = AlertConfig(enableBackgroundBlur: true,
                                           disableOutsideTap: false)

    var body: some View {
        VStack(spacing:0){
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
                        placeholder: "0.0",
                        measurement: "Km",
                        icon: .odometer,
                        focusState: $focusState,
                        focus: .odometer,
                        text: $odometer
                    )
                    ExtractedView(
                        title: "Liters",
                        placeholder: "0",
                        measurement: "L",
                        icon:.liters,
                        focusState: $focusState,
                        focus: .quantity,
                        text: $liters
                    )
                }
            }
            Spacer()
            Button("Save") {
                navManager.pop()
            }
            .buttonStyle(Primary())
            .padding(.bottom,12)
        }
        .onTapGesture {
            focusState = nil
        }
        .onAppear {
            focusState = .totalPrice
        }
        .alert(config: $alert) {
            VStack {
                DatePicker("label", selection: $selectedDate, displayedComponents: [.date])
                    .datePickerStyle(.graphical)
                    .labelsHidden()
                    .accentColor(appState.currentTheme.accentColor)
            }
            .background(RoundedRectangle(cornerRadius: 16).fill(Palette.white))
            .padding()
        }
        .padding(.top,50)
        .background(Palette.greyBackground.ignoresSafeArea(.all))
        .navigationBarBackButtonHidden()
        .toolbar {
            navigationItems()
        }
    }
}

private extension FuelReportView {
    func nextFieldFor(_ current: FuelInputFocusField) {
        if current == .totalPrice {
            focusState = .odometer
        } else if current == .odometer {
            focusState = .quantity
        } else if current == .quantity {
            focusState = .totalPrice
        }
    }
    
    func changeFuelType() {
        if let secondaryFuelType {
            fuelType = secondaryFuelType
        }
    }
}

private extension FuelReportView {
    
    @ToolbarContentBuilder
    func navigationItems() -> some ToolbarContent {
        if let focus = focusState {
            ToolbarItem(placement: .keyboard) {
                HStack {
                    Spacer()
                    Button(action: {
                        nextFieldFor(focus)
                    }, label: {
                        Text("Next")
                            .foregroundStyle(Palette.black)
                            .font(Typography.headerM)
                    })
                }
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
                    changeFuelType()
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }, label: {
                    HStack {
                        Image(.fuelType)
                            .resizable()
                            .frame(width: 16, height: 16)
                            .tint(Palette.black)
                        Text(fuelType.rawValue)
                            .fixedSize()
                    }
                    .padding(8)
                })
                .disabled(secondaryFuelType == nil)
                .buttonStyle(SecondaryCapsule())
                .transaction { $0.animation = nil }
                Button(action: {
                    focusState = nil
                    alert.present()
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }, label: {
                    HStack {
                        Image(.day)
                            .resizable()
                            .frame(width: 16, height: 16)
                            .tint(Palette.black)
                        Text(selectedDate.formatDate(with: "dd MMM YYYY"))
                            .fixedSize()
                    }
                    .padding(8)
                })
                .buttonStyle(SecondaryCapsule())
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
            .environment(SceneDelegate())
    }
}

struct ExtractedView: View {
    @Environment(AppState.self) var appState: AppState

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
                        .fill(text.isEmpty ? Palette.greyLight : appState.currentTheme.colors.background)
                        .frame(width: 32, height: 32)
                    Image(icon)
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(text.isEmpty ? Palette.greyInput : appState.currentTheme.accentColor)
                }
                TextField(placeholder, text: $text)
                    .foregroundStyle(Palette.black)
                    .font(Typography.headerM)
                    .padding(.leading,12)
                    .keyboardType(.decimalPad)
                    .focused($focusState, equals: focus)
                Spacer()
                Text(measurement)
                    .foregroundStyle(Palette.black)
                    .font(Typography.headerM)
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
