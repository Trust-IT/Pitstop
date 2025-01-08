//
//  AnalyticsFuelView.swift
//  Hurricane
//
//  Created by Asya Tealdi on 12/05/22.
//

import SwiftUI

struct AnalyticsFuelView: View {
    @ObservedObject var categoryVM: CategoryViewModel
    @EnvironmentObject var utilityVM: UtilityViewModel
    var body: some View {
        VStack {
            CustomList {
                if categoryVM.fuelGraphData.count >= 2 {
                    Section {
                        VStack {
                            HStack {
                                VStack(alignment: .leading) {
                                    Spacer()
                                    let formattedCost = String(format: "%.2f", categoryVM.fuelEff)
                                    Text("\(formattedCost) L/100 \(utilityVM.unit)")
                                        .font(Typography.headerL)
                                        .padding(1)
                                    Text(String(localized: "Efficiency"))
                                        .foregroundColor(Palette.greyHard)
                                }
                                Spacer()
//                            Text(" ▼ 12 % ")
//                                .font(Typography.headerS)
//                                .foregroundColor(Palette.greenHighlight)
                            }
                            .padding(-3)
                            HStack {
                                FuelGraphView(categoryVM: categoryVM, data: categoryVM.fuelGraphData)
                                    .frame(height: 200)
                                    .padding(.top, 25)
                                    .padding(1)
                            }
                            .padding(-15)

                            Spacer()
                        }
                    }
                }

                Section {
                    FuelListView(categoryVM: categoryVM)
                        .padding(4)
                }
            }
        }
        .background(Palette.greyBackground)
    }
}

struct AnalyticsFuelView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsFuelView(categoryVM: CategoryViewModel())
    }
}
