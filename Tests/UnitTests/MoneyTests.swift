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
