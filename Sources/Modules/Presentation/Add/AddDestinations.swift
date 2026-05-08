//
//  AddDestinations.swift
//  Pitstop
//
//  Created by Ivan Voloshchuk on 29/04/25.
//

import NavigatorUI
import PitstopData
import SwiftUI

enum AddDestinations {
    case fuelReport(input: FuelExpense)
}

extension AddDestinations: NavigationDestination {
    nonisolated var method: NavigationMethod { .managedCover }

    var body: some View {
        switch self {
        case let .fuelReport(expense):
            FuelReportView(fuelExpense: expense)
        }
    }
}

extension AddDestinations: Hashable {
    func hash(into hasher: inout Hasher) {
        switch self {
        case let .fuelReport(expense):
            hasher.combine(0)
            hasher.combine(expense.persistentModelID)
        }
    }
}
