//
//  Category.swift
//  Pitstop
//
//  Created by Ivan Voloshchuk on 31/01/25.
//
import SwiftUI

enum Category: Int, Hashable {
    case maintenance = 1
    case insurance = 2
    case roadTax = 3
    case tolls = 4
    case fines = 5
    case parking = 6
    case other = 7
    case fuel = 8
}

extension Category: CaseIterable {
    var label: String {
        switch self {
        case .fuel:
            NSLocalizedString("Fuel", comment: "")
        case .maintenance:
            NSLocalizedString("Maintenance", comment: "")
        case .insurance:
            NSLocalizedString("Insurance", comment: "")
        case .roadTax:
            NSLocalizedString("Road tax", comment: "")
        case .tolls:
            NSLocalizedString("Tolls", comment: "")
        case .fines:
            NSLocalizedString("Fines", comment: "")
        case .parking:
            NSLocalizedString("Parking", comment: "")
        case .other:
            NSLocalizedString("Other", comment: "")
        }
    }

    var icon: ImageResource {
        switch self {
        case .fuel:
            .fuel
        case .maintenance:
            .wrench
        case .insurance:
            .insurance
        case .roadTax:
            .roadTax
        case .tolls:
            .tolls
        case .fines:
            .fines
        case .parking:
            .parking
        case .other:
            .other
        }
    }

    var color: Color {
        switch self {
        case .fuel:
            Palette.colorYellow
        case .maintenance:
            Palette.colorGreen
        case .insurance:
            Palette.colorOrange
        case .roadTax:
            Palette.colorOrange
        case .tolls:
            Palette.colorOrange
        case .fines:
            Palette.colorOrange
        case .parking:
            Palette.colorViolet
        case .other:
            Palette.colorViolet
        }
    }
}
