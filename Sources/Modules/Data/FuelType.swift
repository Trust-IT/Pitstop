//
//  FuelType.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 03/01/25.
//
import Foundation

enum FuelType: String, Codable, Identifiable, CaseIterable {
    case diesel = "Diesel"
    case gasoline = "Gasoline"
    case propane = "LPG (Propane)"
    case methane = "CNG (Methane)"
    case ethanol = "Ethanol"
    case hydrogen = "Hydrogen"
    case electric = "Electric"
    case none = "None"

    var id: Self { self }
}
