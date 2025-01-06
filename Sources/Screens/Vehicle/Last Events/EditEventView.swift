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
    @EnvironmentObject var utilityVM: UtilityViewModel
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
                    primaryButton: .destructive(Text(String(localized: "Delete"))) {
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
                Image("arrowLeft")
                Text("Back")
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
                        color: Palette.colorViolet
                    )
                )
                Spacer()
                Text("\(fuelExpense.totalPrice) " + utilityVM.currency)
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
                        color: Palette.colorGreen
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
                        color: Palette.colorBlue
                    )
                )
                Spacer()
                Text("\(fuelExpense.odometer) " + utilityVM.unit)
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
                        color: Palette.colorOrange
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
                        icon: fuelExpense.pricePerUnit.isZero ? .priceLiter : .priceLiterColored,
                        color: fuelExpense.pricePerUnit.isZero ? Palette.greyLight : Palette.colorYellow
                    )
                )
                Spacer()
                Text("\(fuelExpense.pricePerUnit) " + utilityVM.currency)
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
                        icon: fuelExpense.quantity.isZero ? .liters : .literColored,
                        color: fuelExpense.quantity.isZero ? Palette.greyLight : Palette.colorOrange
                    )
                )
                Spacer()
                Text("\(fuelExpense.quantity) " + utilityVM.unit)
                    .font(Typography.headerM)
                    .foregroundColor(Palette.black)
            }
            .contentShape(Rectangle())
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
        }
    }
}
