//
//  NumberFormatter+2decimals.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 03/01/25.
//

import Foundation

extension NumberFormatter {
    static var twoDecimalPlaces: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter
    }
}
