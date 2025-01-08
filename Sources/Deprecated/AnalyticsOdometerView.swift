//
//  AnalyticsOdometerView.swift
//  Hurricane
//
//  Created by Asya Tealdi on 12/05/22.
//

import SwiftUI

struct AnalyticsOdometerView: View {
    @ObservedObject var categoryVM: CategoryViewModel
    @ObservedObject var dataVM: DataViewModel
    var body: some View {
        VStack {
            CustomList {
                if categoryVM.odometerGraphData.count >= 2 {
                    Section {
                        VStack {
                            HStack {
                                VStack(alignment: .leading) {
                                    Spacer()
//                                    Text("\(String(Int(dataVM.currentVehicle.first?.odometer ?? 0))) km")
                                    Text("0 km")
                                        .font(Typography.headerL)
                                        .padding(1)
                                    Text(String(localized: "Odometer"))
                                        .foregroundColor(Palette.greyHard)
                                }
                                Spacer()
                            }
                            .padding(-3)
                            HStack {
                                OdometerGraphView(data: categoryVM.odometerGraphData)
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
                    OdometerCostsView(categoryVM: categoryVM, dataVM: dataVM)
                        .padding(4)
                }
            }
        }
        .background(Palette.greyBackground)
    }
}

struct AnalyticsOdometerView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsOdometerView(categoryVM: CategoryViewModel(), dataVM: DataViewModel())
    }
}
