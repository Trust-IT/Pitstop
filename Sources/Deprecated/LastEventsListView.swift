//
//  LastEventsListView.swift
//  Hurricane
//
//  Created by Asya Tealdi on 23/05/22.
//
import SwiftUI

// TODO: Need huge refactoring
// struct LastEventsListView: View {
//    @ObservedObject var dataVM: DataViewModel
//
//    @State private var showEditExpense = false
//    @Environment(\.presentationMode) private var presentationMode
//
//    @ObservedObject var utilityVM: UtilityViewModel
//
//    @State var isfilterSelected = 0 // If  == 0 no filters selected
//
//    var body: some View {
//        NavigationView {
//            ZStack {
//                Palette.greyBackground
//                    .ignoresSafeArea()
//                VStack {
//                    // MARK: CATEGORIES FILTER
//
//                    FiltersRow(dataVM: dataVM, isFilterSelected: $isfilterSelected)
//                    ScrollView(.vertical, showsIndicators: false) {
//                        if dataVM.expenseList.isEmpty {
//                            HStack {
//                                Text(String(localized: "There are no events to show"))
//                                    .font(Typography.TextM)
//                                    .foregroundColor(Palette.greyMiddle)
//                                Spacer()
//                            }
//                            .padding()
//                        }
//
//                        ForEach(dataVM.monthsAmount.sorted(by: <), id: \.self) { month in
//
//                            // MARK: MONTHS
//
//                            ZStack {
//                                Rectangle()
//                                    .frame(height: UIScreen.main.bounds.height * 0.035)
//                                    .foregroundColor(Palette.greyLight)
//                                HStack {
//                                    Text(month.capitalized)
//                                        .foregroundColor(Palette.black)
//                                        .font(Typography.ControlS)
//                                    Spacer()
//                                    if isfilterSelected == 0 {
//                                        Text(String(format: "%2.f", dataVM.getMonthsExpense(expenses: dataVM.expenseList, month: month)) + String(utilityVM.currency))
//                                            .foregroundColor(Palette.black)
//                                            .font(Typography.ControlS)
//                                    } else {
//                                        Text(String(format: "%2.f", dataVM.getMonthsExpense(expenses: dataVM.expenseFilteredList, month: month)) + String(utilityVM.currency))
//                                            .foregroundColor(Palette.black)
//                                            .font(Typography.ControlS)
//                                    }
//                                }
//                                .padding()
//                            }
//
//                            // MARK: LIST
//
//                            if isfilterSelected == 0 {
//                                ForEach(dataVM.expenseList.filter { $0.date.toString(dateFormat: "MMMM") == month }.reversed(), id: \.self) { expense in
//                                    Button(action: {
//                                        showEditExpense.toggle()
//                                    }, label: {
//                                        CategoryComponent(
//                                            category: Category(rawValue: Int(expense.category)) ?? .other,
//                                            date: expense.date, cost: String(expense.price)
//                                        )
//                                    })
//                                }
//                            } else {
//                                ForEach(dataVM.expenseFilteredList.filter { $0.date.toString(dateFormat: "MMMM") == month }.reversed(), id: \.self) { expense in
//                                    Button(action: {
//                                        showEditExpense.toggle()
//                                    }, label: {
//                                        CategoryComponent(
//                                            category: Category(rawValue: Int(expense.category)) ?? .other,
//                                            date: expense.date, cost: String(expense.price)
//                                        )
//                                    })
//                                }
//                            }
//                            NavigationLink(destination:
//                                EditEventView(utilityVM: utilityVM,
//                                              fuelExpense: .constant(.mock()))
//                                    .navigationBarBackButtonHidden(true)
//                                    .navigationBarHidden(true),
//                                isActive: $showEditExpense) {}
//                        }
//                        Spacer()
//                    }
//                }
//            }
//            .navigationBarTitleDisplayMode(.inline)
//            .navigationBarItems(
//                leading:
//                Button(action: {
//                    presentationMode.wrappedValue.dismiss()
//                }, label: {
//                    Text("Cancel")
//                        .font(Typography.headerM)
//                })
//                .accentColor(Palette.greyHard)
//            )
//            .toolbar {
//                ToolbarItem(placement: .principal) {
//                    Text("Last Events")
//                        .font(Typography.headerM)
//                        .foregroundColor(Palette.black)
//                }
//            }
//            .onAppear {
//                dataVM.getExpensesCoreData(filter: nil, storage: { storage in
//                    dataVM.expenseFilteredList = storage
//                })
//                dataVM.getTotalExpense(expenses: dataVM.expenseList)
//                dataVM.getMonths(expenses: dataVM.expenseList)
//                //                print("appeared")
//            }
//        }
//    }
// }

struct FiltersRow: View {
    @State private var parkingIsPressed = false
    @State private var otherIsPressed = false
    @State private var finesIsPressed = false
    @State private var fuelIsPressed = false
    @State private var insuranceIsPressed = false
    @State private var tollsIsPressed = false
    @State private var maintenanceIsPressed = false
    @State private var roadTaxIsPressed = false

    @State var curretFilter: [Int] = [] // Array to store the filters used

    @Binding var isFilterSelected: Int
    //    @Binding var month: String

    let impactMed = UIImpactFeedbackGenerator(style: .medium)

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                Button("Fuel") {
                    impactMed.impactOccurred()
                    fuelIsPressed.toggle()

                    if fuelIsPressed == true {
                        isFilterSelected += 1
                        curretFilter.append(Category.fuel.rawValue)
                    } else {
                        isFilterSelected -= 1
                        if let index = curretFilter.firstIndex(of: Category.fuel.rawValue) { curretFilter.remove(at: index) }
                    }
                }
                .buttonStyle(FilterButton(isPressed: $fuelIsPressed))

                Button("Maintenance") {
                    impactMed.impactOccurred()
                    maintenanceIsPressed.toggle()

                    if maintenanceIsPressed == true {
                        isFilterSelected += 1
                        curretFilter.append(Category.maintenance.rawValue)
                    } else {
                        isFilterSelected -= 1
                        if let index = curretFilter.firstIndex(of: Category.maintenance.rawValue) { curretFilter.remove(at: index) }
                    }
                }
                .buttonStyle(FilterButton(isPressed: $maintenanceIsPressed))

                Button("Tolls") {
                    impactMed.impactOccurred()
                    tollsIsPressed.toggle()

                    if tollsIsPressed == true {
                        isFilterSelected += 1
                        curretFilter.append(Category.tolls.rawValue)
                    } else {
                        isFilterSelected -= 1
                        if let index = curretFilter.firstIndex(of: Category.tolls.rawValue) { curretFilter.remove(at: index) }
                    }
                }
                .buttonStyle(FilterButton(isPressed: $tollsIsPressed))

                Button("Insurance") {
                    impactMed.impactOccurred()
                    insuranceIsPressed.toggle()
                    if insuranceIsPressed == true {
                        isFilterSelected += 1
                        curretFilter.append(Category.insurance.rawValue)
                    } else {
                        isFilterSelected -= 1
                        if let index = curretFilter.firstIndex(of: Category.insurance.rawValue) { curretFilter.remove(at: index) }
                    }
                }
                .buttonStyle(FilterButton(isPressed: $insuranceIsPressed))

                Button("Road Tax") {
                    impactMed.impactOccurred()
                    roadTaxIsPressed.toggle()
                    if roadTaxIsPressed == true {
                        isFilterSelected += 1
                        curretFilter.append(Category.roadTax.rawValue)
                    } else {
                        isFilterSelected -= 1
                        if let index = curretFilter.firstIndex(of: Category.roadTax.rawValue) { curretFilter.remove(at: index) }
                    }
                }
                .buttonStyle(FilterButton(isPressed: $roadTaxIsPressed))

                Button("Fines") {
                    impactMed.impactOccurred()
                    finesIsPressed.toggle()

                    if finesIsPressed == true {
                        isFilterSelected += 1
                        curretFilter.append(Category.fines.rawValue)
                    } else {
                        isFilterSelected -= 1
                        if let index = curretFilter.firstIndex(of: Category.fines.rawValue) { curretFilter.remove(at: index) }
                    }
                }
                .buttonStyle(FilterButton(isPressed: $finesIsPressed))

                Button("Parking") {
                    impactMed.impactOccurred()
                    parkingIsPressed.toggle()
                    if parkingIsPressed == true {
                        isFilterSelected += 1
                        curretFilter.append(Category.parking.rawValue)
                    } else {
                        isFilterSelected -= 1
                        if let index = curretFilter.firstIndex(of: Category.parking.rawValue) { curretFilter.remove(at: index) }
                    }
                }
                .buttonStyle(FilterButton(isPressed: $parkingIsPressed))

                Button("Other") {
                    impactMed.impactOccurred()
                    otherIsPressed.toggle()
                    if otherIsPressed == true {
                        isFilterSelected += 1
                        curretFilter.append(Category.other.rawValue)
                    } else {
                        isFilterSelected -= 1
                        if let index = curretFilter.firstIndex(of: Category.other.rawValue) { curretFilter.remove(at: index) }
                    }
                }
                .buttonStyle(FilterButton(isPressed: $otherIsPressed))
            }
            .padding(.leading)
            .padding(.top, 25)
            .padding(.bottom, 5)
        }
    }
}

struct FilterButton: ButtonStyle {
    @Binding var isPressed: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(10)
            .padding(.horizontal, 7)
            .font(Typography.ControlS)
            .background(isPressed ? Palette.black : Palette.greyLight)
            .foregroundColor(isPressed ? Palette.white : Palette.black)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
