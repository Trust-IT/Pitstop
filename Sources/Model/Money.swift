//
//  Money.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 21/01/25.
//

import Foundation

struct Money: Codable {
    var amount: Decimal
    var currency: Locale.Currency

    init(stringValue: String, currency: Locale.Currency = Locale.current.currency ?? Locale.Currency("EUR")) {
        self.currency = currency
        let sanitized = stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
        amount = Decimal(string: sanitized, locale: .current) ?? 0
    }

    init(value: Double, currency: Locale.Currency = Locale.current.currency ?? Locale.Currency("EUR")) {
        self.currency = currency
        amount = Decimal(value)
    }

    init(value: Decimal, currency: Locale.Currency = Locale.current.currency ?? Locale.Currency("EUR")) {
        self.currency = currency
        amount = value
    }
}

extension Money: CustomStringConvertible {
    var description: String {
        amount.formatted(.currency(code: currency.identifier))
    }
}

extension Money: Equatable {}

extension Money {
    static func + (lhs: Money, rhs: Money) -> Money {
        precondition(lhs.currency == rhs.currency, "Currency mismatch")
        return Money(value: lhs.amount + rhs.amount, currency: lhs.currency)
    }
}
