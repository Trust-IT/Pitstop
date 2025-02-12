//
//  BottomContentView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 14/05/22.
//

import PDFKit
import SwiftData
import SwiftUI

struct BottomContentView: View {
    @EnvironmentObject private var navManager: NavigationManager
    @EnvironmentObject var vehicleManager: VehicleManager
    @Environment(\.modelContext) private var modelContext

    @State private var viewAllNumbers = false
    @State private var viewAllEvents = false
    @State private var showEventEdit = false
    @State private var selectedFuelExpense: FuelExpense = .mock()
    @State private var newNumberAlert: AlertConfig = .init(
        enableBackgroundBlur: false,
        disableOutsideTap: false,
        transitionType: .slide
    )

    var body: some View {
        VStack(spacing: 0) {
            // MARK: LAST EVENTS

            titleSection(
                sectionTitle: "Last events",
                showViewAll: !vehicleManager.currentVehicle.fuelExpenses.isEmpty,
                viewAllAction: {
                    viewAllEvents.toggle()
                }
            )
            .padding()
            .padding(.top, 10)
            .padding(.bottom, -10)
            .sheet(isPresented: $viewAllEvents) { LastEventsView() }

            if vehicleManager.currentVehicle.fuelExpenses.isEmpty {
                HStack {
                    Text(LocalizedStringKey("There are no events to show"))
                        .font(Typography.TextM)
                        .foregroundColor(Palette.greyMiddle)
                    Spacer()
                }
                .padding()
            } else {
                ForEach(vehicleManager.currentVehicle.sortedFuelExpenses.prefix(4), id: \.id) { fuelExpense in
                    Button(action: {
                        selectedFuelExpense = fuelExpense
                        showEventEdit.toggle()
                    }, label: {
                        CategoryComponent(
                            category: .fuel,
                            date: fuelExpense.date,
                            cost: fuelExpense.totalPrice.description
                        )
                    })
                }
            }

            // MARK: DOCUMENTS

            titleSection(
                sectionTitle: "Documents",
                showViewAll: false
            )
            .padding()
            .padding(.top, 10)
            .padding(.bottom, -10)

            DocumentRowView()

            titleSection(
                sectionTitle: "Useful contacts",
                showViewAll: !vehicleManager.currentVehicle.numbers.isEmpty,
                viewAllAction: {
                    viewAllNumbers.toggle()
                }
            )
            .padding()
            .padding(.top, 10)
            .padding(.bottom, -10)

            // MARK: IMPORTANT NUMBERS

            ScrollView(.horizontal, showsIndicators: false) {
                VStack {
                    Spacer(minLength: 12)
                    HStack {
                        ForEach(vehicleManager.currentVehicle.numbers) { number in
                            Button(action: {
                                UIApplication.shared.open(URL(string: "tel://" + number.telephone)!)
                            }, label: {
                                ElementCellView(title: number.title, subtitle: number.telephone, icon: .wrench)
                            })
                        }
                        Button(action: {
                            newNumberAlert.present()
                        }, label: {
                            AddElementView(label: "Add contact")
                        })
                    }
                    Spacer(minLength: 16)
                }
            }
            .safeAreaInset(edge: .trailing, spacing: 0) {
                Spacer()
                    .frame(width: 16)
            }
            .safeAreaInset(edge: .leading, spacing: 0) {
                Spacer()
                    .frame(width: 16)
            }

            // Trick for scroll space, if you remove this you will see the problem
            Text("")
                .padding(.vertical, 35)
            Spacer()
        }
        .sheet(isPresented: $showEventEdit) {
            EditEventView(fuelExpense: $selectedFuelExpense)
        }
        .sheet(isPresented: $viewAllNumbers) {
            ImportantNumbersView()
                .interactiveDismissDisabled(true)
        }
        .alert(config: $newNumberAlert) {
            AddNumberView(alert: $newNumberAlert)
                .environment(\.modelContext, modelContext)
                .environmentObject(vehicleManager)
        }
    }
}

private extension BottomContentView {
    @ViewBuilder
    func titleSection(
        sectionTitle: LocalizedStringKey,
        showViewAll: Bool,
        viewAllAction: (() -> Void)? = nil
    ) -> some View {
        HStack {
            Text(sectionTitle)
                .foregroundColor(Palette.black)
                .font(Typography.headerL)
            Spacer()
            if showViewAll, let viewAllAction {
                HStack {
                    Button(action: {
                        viewAllAction()
                    }, label: {
                        Text("View all")
                            .font(Typography.ControlS)
                            .foregroundColor(Palette.greyMiddle)
                    })
                }
            }
        }
    }
}

// struct BottomContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        BottomContentView()
//
//    }
// }

struct CategoryComponent: View {
    var category: Category
    var date: Date
    var cost: String

    @Environment(AppState.self) var appState: AppState

    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .frame(width: 32, height: 32)
                    .foregroundColor(Palette.greyLight)
                Image(category.icon)
                    .resizable()
                    .frame(width: 16, height: 16)
                    .tint(Palette.black)
            }
            VStack(alignment: .leading) {
                HStack {
                    Text(category.label)
                        .foregroundColor(Palette.black)
                        .font(Typography.headerS)
                    Spacer()
                    Text("-\(cost) \(appState.currency)")
                        .foregroundColor(Palette.greyHard)
                        .font(Typography.headerS)
                        .padding(.trailing, -10)
                }
                Text(date.formatDate())
                    .foregroundColor(Palette.greyMiddle)
                    .font(Typography.TextM)
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}
