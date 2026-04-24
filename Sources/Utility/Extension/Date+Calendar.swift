//
//  Date+Calendar.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 27/12/24.
//

import Foundation

extension Date {
    func addingYears(_ years: Int) -> Date? {
        Calendar.current.date(byAdding: .year, value: years, to: self)
    }

    func formatDate(with format: String = "MMM d, EE") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate(format)
        return dateFormatter.string(from: self)
    }

    func toString(dateFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
