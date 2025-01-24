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
    enum Currency: String, Codable {
        case USD
        case EUR

        var symbol: String {
            switch self {
            case .USD:
                "$"
            case .EUR:
                "€"
            }
        }
    }
}

extension Money: CustomStringConvertible {
    var description: String {
        Money.decimalFormatter().string(from: amount as NSNumber) ?? "X"
    }
}

extension Money {
    static func decimalFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }
}

extension Money: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let amountDecimal = try? container.decode(Decimal.self, forKey: .amount) {
            amount = amountDecimal
        } else if let amountString = try? container.decode(String.self, forKey: .amount) {
            if let decimalAmount = Decimal(string: amountString) {
                amount = decimalAmount
            } else {
                throw DecodingError.invalidAmountValue
            }
        } else if let amountDouble = try? container.decode(Double.self, forKey: .amount) {
            amount = Decimal(amountDouble)
        } else {
            throw DecodingError.invalidAmountValue
        }
        currency = try container.decode(Currency.self, forKey: .currency)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(amount, forKey: .amount)
        try container.encode(currency, forKey: .currency)
    }

    private enum CodingKeys: String, CodingKey {
        case amount
        case currency
    }

    enum DecodingError: Error {
        case invalidDecimalValue
        case invalidAmountValue

        var localizedDescription: String {
            switch self {
            case .invalidDecimalValue:
                "Invalid decimal value in string format"
            case .invalidAmountValue:
                "Amount value must be a valid String or Double"
            }
        }
    }
}
