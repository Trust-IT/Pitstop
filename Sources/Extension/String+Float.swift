//
//  String+Float.swift
//  Pitstop
//
//  Created by Ivan Voloshchuk on 24/01/25.
//
import Foundation

extension String {
    func toFloat(using formatter: NumberFormatter = Money.decimalFormatter()) -> Float? {
        guard let number = formatter.number(from: self) else { return nil }
        return number.floatValue
    }
}
