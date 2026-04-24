//
//  Float+Round.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 03/01/25.
//
import Foundation

extension Float {
    /// Rounds the float to the specified number of decimal places
    func rounded(toPlaces places: Int) -> Float {
        let multiplier = pow(10.0, Float(places))
        return (self * multiplier).rounded() / multiplier
    }

    func toString(withFormat format: String = "%.2f") -> String {
        String(format: format, self)
    }
}
