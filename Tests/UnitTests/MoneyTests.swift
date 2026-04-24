//
//  MoneyTests.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 21/01/25.
//

import Foundation
@testable import Pitstop_APP
import Testing

@Suite("Money")
struct MoneyTests {
    private let eur = Locale.Currency("EUR")
    private let usd = Locale.Currency("USD")

    @Test func initDecimal() {
        let money = Money(value: Decimal(string: "12.50")!, currency: eur)
        #expect(money.amount == Decimal(string: "12.50")!)
        #expect(money.currency == eur)
    }

    @Test func initDouble() {
        let money = Money(value: 42.0, currency: usd)
        #expect(money.amount == Decimal(42.0))
        #expect(money.currency == usd)
    }

    @Test func initStringValid() {
        let money = Money(stringValue: "100", currency: eur)
        #expect(money.amount == 100)
    }

    @Test func initStringInvalidFallsToZero() {
        let money = Money(stringValue: "invalid", currency: eur)
        #expect(money.amount == 0)
    }

    @Test func addition() {
        let a = Money(value: Decimal(string: "10.50")!, currency: eur)
        let b = Money(value: Decimal(string: "5.25")!, currency: eur)
        let result = a + b
        #expect(result.amount == Decimal(string: "15.75")!)
        #expect(result.currency == eur)
    }

    @Test func equatable() {
        let a = Money(value: Decimal(string: "10.00")!, currency: eur)
        let b = Money(value: Decimal(string: "10.00")!, currency: eur)
        let c = Money(value: Decimal(string: "9.00")!, currency: eur)
        #expect(a == b)
        #expect(a != c)
    }

    @Test func descriptionNonEmpty() {
        let money = Money(value: Decimal(string: "12.50")!, currency: eur)
        #expect(!money.description.isEmpty)
    }
}

@Suite("Money Codable")
struct MoneyCodableTests {
    @Test func roundtrip() throws {
        let original = Money(value: Decimal(string: "456.78")!, currency: Locale.Currency("EUR"))
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(Money.self, from: data)
        #expect(decoded.amount == original.amount)
        #expect(decoded.currency == original.currency)
    }
}
