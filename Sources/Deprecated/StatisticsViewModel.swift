//
//  StatisticsViewModel.swift
//  Hurricane
//
//  Created by Asya Tealdi on 23/05/22.
//

import Foundation
import SwiftUI

class StatisticsViewModel: ObservableObject {
    @Published var selectedTimeFrame = String(localized: "All time")
    let timeFrames = [String(localized: "Per month"), String(localized: "Per 3 months"), String(localized: "Per year"), String(localized: "All time")]

    @Published var categoryExpensesList = [ExpenseViewModel]()
}
