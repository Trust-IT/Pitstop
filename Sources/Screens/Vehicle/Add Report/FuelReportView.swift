//
//  FuelReportView.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 23/01/25.
//

import SwiftUI

struct FuelReportView: View {
    @EnvironmentObject var vehicleManager: VehicleManager
    @EnvironmentObject private var navManager: NavigationManager
    @Environment(AppState.self) var appState: AppState
    @Environment(\.modelContext) private var modelContext
    
    @FocusState private var focusState: FuelInputFocusField?
    @State private var totalPrice = ""
    @State private var odometer : String
    @State private var liters : String
    @State private var fuelType: FuelType = .diesel
    @State private var secondaryFuelType: FuelType?
    @State private var selectedDate = Date()
    @State private var alert = AlertConfig(enableBackgroundBlur: true,
                                           disableOutsideTap: false)
    let fuelExpense: FuelExpense
    init(fuelExpense: FuelExpense) {
        self.fuelExpense = fuelExpense
        self.odometer = fuelExpense.odometer != 0 ? fuelExpense.odometer.description : ""
        self.liters = fuelExpense.quantity != 0 ? fuelExpense.quantity.description : ""
    }

    var body: some View {
        VStack(spacing:0){
            ScrollView{
                VStack(spacing:14){
                    FuelInputTextField(
                        title: "Total",
                        placeholder: "\(fuelExpense.totalPrice)",
                        measurement: "€",
                        icon: .category,
                        focusState: $focusState,
                        focus: .totalPrice,
                        text: $totalPrice
                    )
                    FuelInputTextField(
                        title: "Odometer",
                        placeholder: "\(vehicleManager.currentVehicle.odometer)",
                        measurement: "Km",
                        icon: .odometer,
                        focusState: $focusState,
                        focus: .odometer,
                        text: $odometer
                    )
                    FuelInputTextField(
                        title: "Liters",
                        placeholder: "\(fuelExpense.quantity)",
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
            .disabled(!areFieldsValid)
            .buttonStyle(Primary())
            .padding(.bottom,12)
        }
        .onAppear {
            focusState = .totalPrice
            
            // Note: The vehicleManager is passed down when the body is called (as EnvObj),
            // so it doesn't yet exist during the initialization phase, hence it cause runtime crash
            // To fix this, we need to move the initialization of this values into the onAppear
            self.fuelType = vehicleManager.currentVehicle.mainFuelType
            self.secondaryFuelType = vehicleManager.currentVehicle.secondaryFuelType
        }
        .alert(config: $alert) {
            VStack {
                // TODO: Fix date range
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
        if fuelType == vehicleManager.currentVehicle.mainFuelType {
            fuelType = secondaryFuelType ?? fuelType
        } else {
            fuelType = vehicleManager.currentVehicle.mainFuelType
        }
    }
    
    var areFieldsValid: Bool {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .decimal
        
        guard let totalPriceValue = formatter.number(from: totalPrice)?.doubleValue,
              let odometerValue = formatter.number(from: odometer)?.doubleValue,
              let litersValue = formatter.number(from: liters)?.doubleValue else {
            return false
        }
        return totalPriceValue > 0 && odometerValue > 0 && litersValue > 0
    }
}

private extension FuelReportView {
    
    @ToolbarContentBuilder
    func navigationItems() -> some ToolbarContent {
        if let focus = focusState {
            ToolbarItem(placement: .keyboard) {
                HStack {
                    Button(action: {
                        focusState = nil
                    }, label: {
                        Image(systemName: "keyboard.chevron.compact.down")
                    })
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
        FuelReportView(fuelExpense: FuelExpense.mock())
            .environmentObject(VehicleManager())
            .environment(AppState())
            .environmentObject(NavigationManager())
            .environment(SceneDelegate())
    }
}

struct FuelInputTextField: View {
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
