//
//  ServiceCategory.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 27/12/24.
//

import SwiftUI

enum ServiceCategory: String, Codable, CaseIterable, Identifiable {
    case maintenance = "Maintenance"
    case insurance = "Insurance"
    case roadTax = "Road Tax"
    case tolls = "Tolls"
    case fines = "Fines"
    case parking = "Parking"
    case other = "Other"

    var id: Self { self }

    var icon: ImageResource {
        switch self {
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
