//
//  AnalyticsCostView.swift
//  Hurricane
//
//  Created by Asya Tealdi on 12/05/22.
//

import SwiftUI

struct AnalyticsCostView: View {
    @ObservedObject var categoryVM: CategoryViewModel
    @ObservedObject var dataVM: DataViewModel
    var body: some View {
        VStack {
            CustomList {
                Section {
                    CostGraphView(categoryVM: categoryVM, dataVM: dataVM)
                        .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
                        .frame(height: 180)
                }
                Section {
                    CostsListView(categoryVM: categoryVM, dataVM: dataVM)
                }
                Section {
                    // needed for scroll
                }
            }
        }
        .background(Palette.greyBackground)
    }
}

struct CostGraphView: View {
    @Environment(AppState.self) var appState: AppState
    @ObservedObject var categoryVM: CategoryViewModel
    @ObservedObject var dataVM: DataViewModel
    var value = "50%"
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                VStack(alignment: .leading) {
                    let formattedCost = String(format: "%.0f", dataVM.totalExpense)
                    Text("\(formattedCost) \(appState.currency)")
                        .font(Typography.headerL)
                        .padding(1)
                    Text("Cost structure")
                        .foregroundColor(Palette.greyHard)
                }
                Spacer()
            }
            Spacer()
            // GRAPH LINE
            LineGraph(categoryVM: categoryVM)
            Spacer()

            // LABELS
            GeometryReader { geo in
                VStack(alignment: .leading) {
                    HStack {
                        HStack {
                            RoundedRectangle(cornerRadius: 5)
                                .frame(width: 16, height: 16, alignment: .topLeading)
                                .foregroundColor(Palette.colorOrange)
                            Text(String(localized: "Taxes"))
                            let formattedTaxesPerc = String(format: "%.0f", categoryVM.taxesPercentage)
                            Text("\(formattedTaxesPerc) %")
                                .foregroundColor(Palette.greyHard)
                        }
                        .frame(width: geo.size.width * 0.40, alignment: .leading)

                        HStack {
                            RoundedRectangle(cornerRadius: 5)
                                .frame(width: 16, height: 16, alignment: .topLeading)
                                .foregroundColor(Palette.colorYellow)
                            Text(String(localized: "Fuel"))
                            let formattedPerc = String(format: "%.0f", categoryVM.fuelPercentage)
                            Text("\(formattedPerc) %")
                                .foregroundColor(Palette.greyHard)
                        }
                        .frame(width: geo.size.width * 0.60, alignment: .leading)
                    }

                    HStack {
                        HStack {
                            RoundedRectangle(cornerRadius: 5)
                                .frame(width: 16, height: 16, alignment: .topLeading)
                                .foregroundColor(Palette.colorViolet)
                            Text(String(localized: "Other"))
                            let formattedOtherPerc = String(format: "%.0f", categoryVM.otherPercentage)
                            Text("\(formattedOtherPerc) %")
                                .foregroundColor(Palette.greyHard)
                        }
                        .frame(width: geo.size.width * 0.40, alignment: .leading)
                        HStack {
                            RoundedRectangle(cornerRadius: 5)
                                .frame(width: 16, height: 16, alignment: .center)
                                .foregroundColor(Palette.colorGreen)
                            Text(String(localized: "Maintenance"))
                            let formattedMainPerc = String(format: "%.0f", categoryVM.maintainancePercentage)
                            Text("\(formattedMainPerc) %")
                                .foregroundColor(Palette.greyHard)
                        }
                        .frame(width: geo.size.width * 0.60, alignment: .leading)
                    }
                }
                .padding(.top, 20)
//                Spacer()
            }
        }
    }
}

struct LineGraph: View {
    @ObservedObject var categoryVM: CategoryViewModel

    var body: some View {
        VStack(alignment: .leading) {
            cell()
        }
    }

    @ViewBuilder
    func cell() -> some View {
        RoundedRectangle(cornerRadius: 5)
            .frame(width: UIScreen.main.bounds.width * 0.815, height: 23, alignment: .top)
            .foregroundColor(.white)
            .overlay(content: {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        HStack(spacing: 0) {
                            Rectangle()
                                .foregroundColor(Palette.colorYellow)
                                .frame(width: geometry.size.width * CGFloat(categoryVM.fuelPercentage / 100), height: geometry.size.height)
                            Rectangle()
                                .foregroundColor(Palette.colorOrange)
                                .frame(width: geometry.size.width * CGFloat(categoryVM.taxesPercentage / 100), height: geometry.size.height)
                            Rectangle()
                                .foregroundColor(Palette.colorViolet)
                                .frame(width: geometry.size.width * CGFloat(categoryVM.otherPercentage / 100), height: geometry.size.height)
                            Rectangle()
                                .foregroundColor(Palette.colorGreen)
                                .frame(width: geometry.size.width * CGFloat(categoryVM.maintainancePercentage / 100), height: geometry.size.height)
                        }
                    }
                }
            })
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
