//
//  EditEventView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 31/05/22.
//

import SwiftData
import SwiftUI

struct EditEventView: View {
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var vehicleManager: VehicleManager
    @Environment(AppState.self) var appState: AppState
    @State var showDeleteAlert = false

    @Binding var fuelExpense: FuelExpense

    var body: some View {
        NavigationView {
            VStack {
                fuelEventListFields()
            }
            .background(Palette.greyBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    backButton
                }

                ToolbarItem(placement: .principal) {
                    categoryLabel
                }
            }
            .overlay(
                VStack {
                    Spacer(minLength: UIScreen.main.bounds.size.height * 0.78)
                    Button(action: {
                        showDeleteAlert.toggle()
                    }, label: {
                        DeleteButton(title: "Delete report")
                    })
                    .buttonStyle(Primary())
                    Spacer()
                }
            )
            .alert(isPresented: $showDeleteAlert) {
                Alert(
                    title: Text(String(localized: "Are you sure you want to delete this report?")),
                    message: Text(String(localized: "This action cannot be undone")),
                    primaryButton: .destructive(Text(PitstopAPPStrings.Common.delete)) {
                        fuelExpense.delete(context: modelContext)
                        vehicleManager.currentVehicle.fuelExpenses.removeAll { $0.id == fuelExpense.id }
                        presentationMode.wrappedValue.dismiss()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }

    private var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            HStack {
                Text(PitstopAPPStrings.Common.cancel)
                    .font(Typography.headerM)
            }
            .accentColor(Palette.greyHard)
        })
    }

    private var categoryLabel: some View {
        Text("Fuel")
            .font(Typography.headerM)
            .foregroundColor(Palette.black)
    }

    @ViewBuilder
    private func fuelEventListFields() -> some View {
        CustomList {
            // MARK: AMOUNT

            HStack {
                CategoryRow(
                    input:
                    .init(
                        title: String(localized: "Cost"),
                        icon: .other,
                        color: Palette.greyLight
                    )
                )
                Spacer()
                Text("\(fuelExpense.totalPrice) " + appState.currency)
                    .font(Typography.headerM)
                    .foregroundColor(Palette.black)
            }
            .contentShape(Rectangle())
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))

            // MARK: DATE

            HStack {
                CategoryRow(
                    input: .init(
                        title: String(localized: "Day"),
                        icon: .day,
                        color: Palette.greyLight
                    )
                )
                Spacer()
                Text(fuelExpense.date.formatDate())
                    .font(Typography.headerM)
                    .foregroundColor(Palette.black)
            }
            .contentShape(Rectangle())
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))

            // MARK: ODOMETER

            HStack {
                CategoryRow(
                    input: .init(
                        title: String(localized: "Odometer"),
                        icon: .odometer,
                        color: Palette.greyLight
                    )
                )
                Spacer()
                Text("\(fuelExpense.odometer) " + appState.unit)
                    .font(Typography.headerM)
                    .foregroundColor(Palette.black)
            }
            .contentShape(Rectangle())
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))

            // MARK: FUEL TYPE

            HStack {
                CategoryRow(
                    input: .init(
                        title: String(localized: "Fuel type"),
                        icon: .fuelType,
                        color: Palette.greyLight
                    )
                )
                Spacer()
                Text(fuelExpense.fuelType.rawValue)
                    .font(Typography.headerM)
                    .foregroundColor(Palette.black)
            }
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))

            // MARK: PRICE LITER

            HStack {
                CategoryRow(
                    input: .init(
                        title: String(localized: "Price/Liter"),
                        icon: .priceLiter,
                        color: Palette.greyLight
                    )
                )
                Spacer()
                Text("\(fuelExpense.pricePerUnit) " + appState.currency)
                    .font(Typography.headerM)
                    .foregroundColor(Palette.black)
            }
            .contentShape(Rectangle())
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))

            // MARK: LITER

            HStack {
                CategoryRow(
                    input: .init(
                        title: String(localized: "Liters"),
                        icon: .liters,
                        color: Palette.greyLight
                    )
                )
                Spacer()
                Text("\(fuelExpense.quantity) " + appState.unit)
                    .font(Typography.headerM)
                    .foregroundColor(Palette.black)
            }
            .contentShape(Rectangle())
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
        }
    }
}
