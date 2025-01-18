//
//  AnalyticsOverviewView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 06/05/22.
//

import SwiftUI

struct AnalyticsOverviewView: View {
    @StateObject var statisticsVM = StatisticsViewModel()
    @ObservedObject var dataVM: DataViewModel
    @ObservedObject var categoryVM: CategoryViewModel

    @State private var pickerTabs = [String(localized: "Overview"), String(localized: "Costs"), String(localized: "Fuel"), String(localized: "Odometer")]
    @State var pickedTab = ""

    @Namespace var animation

    var body: some View {
        if categoryVM.expenseList.isEmpty {
            ZStack {
                Palette.white.ignoresSafeArea()
                VStack {
                    Spacer()
                    GifView("loadingStats", size: .init(width: 300, height: 300))
                        .frame(width: 300, height: 300)
                    Text(String(localized: "No data to show"))
                        .foregroundColor(Palette.black)
                        .font(Typography.headerM)
                    Spacer()
                }
            }
        }
        VStack {
//            AnalyticsHeaderView()
//                .padding(10)
//                .frame(height: 40)

            if categoryVM.currentPickerTab == String(localized: "Overview") {
                OverviewView(dataVM: dataVM, categoryVM: categoryVM)
            } else if categoryVM.currentPickerTab == String(localized: "Costs") {
                AnalyticsCostView(categoryVM: categoryVM, dataVM: dataVM)
            } else if categoryVM.currentPickerTab == String(localized: "Fuel") {
                AnalyticsFuelView(categoryVM: categoryVM)
            } else {
                AnalyticsOdometerView(categoryVM: categoryVM, dataVM: dataVM)
            }
        }
        .background(Palette.greyBackground)
        .overlay(content: {
            VStack {
                Spacer()
                CustomSegmentedPicker()
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                    .background(.ultraThinMaterial)
            }
        })
        .background(Palette.greyLight)
    }

    func CustomSegmentedPicker() -> some View {
        ZStack {
            HStack(alignment: .center, spacing: 10) {
                ForEach(pickerTabs, id: \.self) { tab in
                    if categoryVM.currentPickerTab == tab {
                        Text(tab)
                            .fixedSize()
                            .frame(maxWidth: .infinity)
                            .padding(10)
                            .font(Typography.headerXS)
                            .foregroundColor(Palette.white)
                            .background {
                                if categoryVM.currentPickerTab == tab {
                                    Capsule()
                                        .fill(Palette.black)
                                        .matchedGeometryEffect(id: "pickerTab", in: animation)
                                }
                            }
                            .containerShape(Capsule())
                            .contentShape(Capsule())
                            .onTapGesture {
                                withAnimation(.easeInOut) {
                                    categoryVM.currentPickerTab = tab
                                    let haptic = UIImpactFeedbackGenerator(style: .soft)
                                    haptic.impactOccurred()
                                }
                            }
                    } else {
                        Text(tab)
                            .fixedSize()
                            .frame(maxWidth: .infinity)
                            .padding(10)
                            .font(Typography.headerXS)
                            .foregroundColor(Palette.black)
                            .background {
                                if categoryVM.currentPickerTab == tab {
                                    Capsule()
                                        .fill(Palette.black)
                                        .matchedGeometryEffect(id: "pickerTab", in: animation)
                                }
                            }
                            .containerShape(Capsule())
                            .contentShape(Capsule())
                            .onTapGesture {
                                withAnimation(.easeInOut) {
                                    categoryVM.currentPickerTab = tab
                                    let haptic = UIImpactFeedbackGenerator(style: .soft)
                                    haptic.impactOccurred()
                                }
                            }
                    }
                }
            }
            .padding(.horizontal, 3)
        }
    }
}

// MARK: Overview page

struct OverviewView: View {
    @ObservedObject var dataVM: DataViewModel
    @ObservedObject var categoryVM: CategoryViewModel

    var body: some View {
        CustomList {
            Section {
                CostsListView(categoryVM: categoryVM, dataVM: dataVM)
            }

            Section {
                FuelListView(categoryVM: categoryVM)
                    .padding(2)
            }
            Section {
                OdometerCostsView(categoryVM: categoryVM, dataVM: dataVM)
                    .padding(2)
            }
            Section {}
        }
    }
}

// MARK: Costs List Section

struct CostsListView: View {
    @Environment(AppState.self) var appState: AppState
    @ObservedObject var categoryVM: CategoryViewModel
    @ObservedObject var dataVM: DataViewModel

    var body: some View {
        Section {
            HStack {
                Text("Costs")
                    .font(Typography.headerL)
                Spacer()
                let formattedCost = String(format: "%.0f", dataVM.totalExpense)
                Text("\(formattedCost) \(appState.currency)")
                    .fontWeight(.semibold)
            }
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))

            ForEach(categoryVM.categories, id: \.self) { category in
                HStack {
//                    CategoryRow(title: category.name, icon: category.icon, color: category.color)
                    Spacer()
                    Text(String(category.totalCosts))
                        .font(Typography.headerM)
                        .foregroundColor(Palette.greyHard)
                }
                .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
            }
        }

        .padding(2)
    }
}

// MARK: Fuel data Section

struct FuelListView: View {
    @ObservedObject var categoryVM: CategoryViewModel
    @Environment(AppState.self) var appState: AppState
    var body: some View {
        HStack {
            Text("Fuel")
                .font(Typography.headerL)
            Spacer()
            let formattedCost = String(format: "%.2f", categoryVM.fuelEff)
            Text("\(formattedCost) L/100 \(appState.unit)")
                .fontWeight(.semibold)
                .font(Typography.headerM)
        }
        .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))

        ListCostsAttributes(title: "Expense", value: String(categoryVM.fuelTotal))
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
        ListCostsAttributes(title: "Average price", value: "\(String(categoryVM.avgPrice)) \(appState.currency)/L")
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
        ListCostsAttributes(title: "Refuels", value: String(categoryVM.refuelsPerTime))
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
        ListCostsAttributes(title: "Average days/refuel", value: String(categoryVM.avgDaysRefuel))
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
    }
}

// MARK: Odometer Section

struct OdometerCostsView: View {
    @ObservedObject var categoryVM: CategoryViewModel
    @ObservedObject var dataVM: DataViewModel
    @Environment(AppState.self) var appState: AppState
    var body: some View {
        HStack {
            Text("Odometer")
                .font(Typography.headerL)
            Spacer()
//            Text("\(String(Int(dataVM.currentVehicle.first?.odometer ?? 0))) km")
            Text("0 km")
                .fontWeight(.semibold)
                .font(Typography.headerM)
        }
        .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))

        let formattedAvgOdo = String(format: "%.0f", categoryVM.avgOdometer)
        ListCostsAttributes(title: "Average", value: " \(formattedAvgOdo) \(appState.unit)" + NSLocalizedString("/day", comment: ""))
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
        ListCostsAttributes(title: "Month Total", value: String(categoryVM.odometerTotal))
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
        let formattedEstimatedOdo = String(format: "%.0f", categoryVM.estimatedOdometerPerYear)
        ListCostsAttributes(title: "Estimated km/year", value: "\(formattedEstimatedOdo) \(appState.unit)")
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
    }
}

// MARK: List row

struct ListCostsAttributes: View {
    var title: LocalizedStringKey
    var value: String
    var body: some View {
        HStack {
            Text(title)
                .font(Typography.headerM)
            Spacer()
            Text(value)
                .foregroundColor(Palette.greyHard)
        }
    }
}

// MARK: Analytics Header

//
// struct StatsView_Previews: PreviewProvider {
//    static var previews: some View {
//        AnalyticsOverviewView(dataVM: DataViewModel(), appState: UtilityViewModel())
//    }
// }
