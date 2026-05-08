//
//  LastEventsView.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 06/01/25.
//

import ChassisUI
import PitstopData
import SwiftUI

// TODO: Implement categorization for months + show expense for each month
// Watch LastEventsListView for reference
struct LastEventsView: View {
    @Environment(VehicleManager.self) var vehicleManager: VehicleManager
    @Environment(AppState.self) var appState: AppState
    @Environment(\.dismiss) private var dismiss

    @State private var isFuelFilter: Bool = true
    @State private var fuelExpenses: [FuelExpense] = []

    @State private var showEventEdit = false
    @State private var selectedFuelExpense: FuelExpense = .mock()

    let impactMed = UIImpactFeedbackGenerator(style: .medium)
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Button("Fuel") {
                    // Since I have only one category for now, no need to do something here
                    impactMed.impactOccurred()
                }
                .padding()
                .buttonStyle(FilterButton(isPressed: $isFuelFilter))

                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(fuelExpenses) { fuelExpense in
                        Button(action: {
                            selectedFuelExpense = fuelExpense
                            showEventEdit.toggle()
                        }, label: {
                            CategoryComponent(
                                category: .fuel,
                                date: fuelExpense.date,
                                cost: appState.currency.format(fuelExpense.totalCost)
                            )
                        })
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading:
                Button(action: {
                    dismiss()
                }, label: {
                    Text(PitstopStrings.Localizable.Common.cancel)
                        .font(Typography.headerM)
                })
                .accentColor(Palette.greyHard)
            )
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Last Events")
                        .font(Typography.headerM)
                        .foregroundColor(Palette.black)
                }
            }
        }
        .sheet(
            isPresented: $showEventEdit,
            onDismiss: { updateFuelExpenseList() },
            content: {
                EditEventView(fuelExpense: $selectedFuelExpense)
            }
        )
        .onAppear {
            updateFuelExpenseList()
        }
    }

    private func updateFuelExpenseList() {
        fuelExpenses = vehicleManager.sortedExpenses
    }
}

#Preview {
    LastEventsView()
}
