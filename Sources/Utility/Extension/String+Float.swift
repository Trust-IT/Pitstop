//
//  String+Float.swift
//  Pitstop
//
//  Created by Ivan Voloshchuk on 24/01/25.
//
import Foundation

extension String {
    func toFloat() -> Float? {
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.numberStyle = .decimal
        guard let number = formatter.number(from: self) else { return nil }
        return number.floatValue
    }
}

extension Locale.Currency {
    func format(_ value: some BinaryFloatingPoint) -> String {
        Decimal(Double(value)).formatted(.currency(code: identifier))
    }

    func format(_ value: Decimal) -> String {
        value.formatted(.currency(code: identifier))
    }
}

extension UnitLength {
    /// Formats a value stored in kilometers, converting to this unit for display.
    func format(_ valueInKm: some BinaryFloatingPoint) -> String {
        Measurement(value: Double(valueInKm), unit: UnitLength.kilometers)
            .converted(to: self)
            .formatted(.measurement(width: .abbreviated, usage: .road))
    }

    func format(_ valueInKm: some BinaryInteger) -> String {
        format(Double(valueInKm))
    }
}

extension UnitVolume {
    /// Formats a value stored in liters, converting to this unit for display.
    func format(_ valueInLiters: some BinaryFloatingPoint) -> String {
        Measurement(value: Double(valueInLiters), unit: UnitVolume.liters)
            .converted(to: self)
            .formatted(.measurement(width: .abbreviated))
    }
}
