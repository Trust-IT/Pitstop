//
//  ServiceCategory.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 27/12/24.
//

public enum ServiceCategory: String, Codable, CaseIterable, Identifiable, Sendable {
    case maintenance = "Maintenance"
    case insurance = "Insurance"
    case roadTax = "Road Tax"
    case tolls = "Tolls"
    case fines = "Fines"
    case parking = "Parking"
    case other = "Other"

    public var id: Self { self }
}
