//
//  MoneyTests.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 21/01/25.
//

import Foundation
@testable import Pitstop_APP
import Testing

@Suite("Money model tests")
struct MoneyTests {
    @Test func testInitWithInvalidString() throws {
        // Test for invalid string input
        let money = Money(stringValue: "invalid")
        try #require(money.amount == -1, "Amount should be -1 for an invalid string.")
        try #require(money.description == "-1", "Description should represent the default -1 amount.")
    }

    @Test func testInitWithInvalidSeparator() throws {
        // Test for string with an invalid separator (locale mismatch)
        let money = Money(stringValue: "123.39")
        try #require(money.amount == -1, "Amount should be -1 due to an invalid separator.")
    }

    @Test func testInitWithValidStringDecimal() throws {
        // Test for valid string with a decimal separator
        let money = Money(stringValue: "123,39")
        try #require(money.amount == 123.39, "Amount should correctly parse the decimal value.")
    }

    @Test func testInitWithValidStringNoDecimal() throws {
        // Test for valid string without a decimal point
        let money = Money(stringValue: "12339")
        try #require(money.amount == 12339, "Amount should correctly parse the integer value.")
    }

    @Test func testDescriptionWithZeroAmount() throws {
        // Test for zero amount description
        let money = Money(stringValue: "0")
        try #require(money.description == "0", "Description should correctly display 0.")
    }

    @Test func testDescriptionWithPositiveDecimal() throws {
        // Test for positive decimal amount description
        let money = Money(value: 302.02)
        try #require(money.description == "302,02", "Description should correctly display the positive decimal value.")
    }

    @Test func testDescriptionWithNegativeDecimal() throws {
        // Test for negative decimal amount description
        let money = Money(value: -302.02)
        try #require(money.description == "-302,02", "Description should correctly display the negative decimal value.")
        try #require(money.amount == -302.02)
    }

    @Test func testValueWithLargeDecimal() throws {
        // Test for large decimal value
        let money = Money(value: 320_012_010_323_202.0322302)
        try #require(money.amount == 320_012_010_323_202.0322302)
    }
}

@Suite("Money encoding/decoding tests")
struct MoneyCodableTests {
    @Test func decodingWithValidStringAmount() throws {
        // Given
        let jsonString = """
        {
            "amount": "123.45",
            "currency": "USD"
        }
        """
        let jsonData = jsonString.data(using: .utf8)!

        let money = try JSONDecoder().decode(Money.self, from: jsonData)

        try #require(money.amount == Decimal(string: "123.45"))
        try #require(money.currency == .USD)
    }

    @Test func decodingWithValidDoubleAmount() throws {
        // Given
        let jsonString = """
        {
            "amount": 123.45,
            "currency": "USD"
        }
        """
        let jsonData = jsonString.data(using: .utf8)!

        let money = try JSONDecoder().decode(Money.self, from: jsonData)

        try #require(money.amount == Decimal(123.45))
        try #require(money.currency == .USD)
    }

    @Test func decodingWithInvalidAmount() throws {
        // Given
        let jsonString = """
        {
            "amount": "invalid",
            "currency": "USD"
        }
        """
        let jsonData = jsonString.data(using: .utf8)!

        do {
            _ = try JSONDecoder().decode(Money.self, from: jsonData)
        } catch let error as Money.DecodingError {
            try #require(error == .invalidAmountValue)
        } catch {
            throw error // Re-throw unexpected errors
        }
    }

    @Test func encodingProducesExpectedJSON() throws {
        // Given
        let money = Money(value: 123.45, currency: .USD)
        let encoder = JSONEncoder()

        let jsonData = try encoder.encode(money)

        // All this boilerplate is because JSON serialization
        // does not guarantee the order of keys when encoding a Swift object into JSON.

        let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
        let expectedJSON: [String: Any] = [
            "amount": "123.45",
            "currency": "USD"
        ]

        let expectedData = try JSONSerialization.data(withJSONObject: expectedJSON, options: [.sortedKeys])
        let normalizedJSON = try JSONSerialization.jsonObject(with: expectedData, options: []) as? [String: Any]

        try #require(jsonObject! as NSDictionary == normalizedJSON! as NSDictionary, "Encoded JSON does not match expected JSON")
    }

    @Test func encodingDecoding() throws {
        let originalMoney = Money(stringValue: "456,78", currency: .EUR)

        let jsonData = try JSONEncoder().encode(originalMoney)
        let decodedMoney = try JSONDecoder().decode(Money.self, from: jsonData)

        try #require(decodedMoney.amount == originalMoney.amount)
        try #require(decodedMoney.currency == originalMoney.currency)
    }
}
