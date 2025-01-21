//
//  Money.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 21/01/25.
//

import Foundation

struct Money {
    var amount: Decimal
    var currency: Currency

    init(stringValue: String, currency: Currency = .EUR) {
        self.currency = currency
        let sanitizedValue = stringValue.trimmingCharacters(in: .whitespacesAndNewlines)

        if let decimalValue = Money.decimalFormatter().number(from: sanitizedValue)?.decimalValue {
            amount = decimalValue
        } else {
            amount = -1
        }
    }

    init(value: Double, currency: Currency = .EUR) {
        self.currency = currency
        amount = Decimal(value)
    }
}

extension Money {
    enum Currency: String {
        case USD
        case EUR
    }
}

extension Money: CustomStringConvertible {
    var description: String {
        Money.decimalFormatter().string(from: amount as NSNumber) ?? "X"
    }
}

private extension Money {
    private static func decimalFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }
}
