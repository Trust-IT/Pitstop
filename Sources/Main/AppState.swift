//
//  AppState.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 06/05/22.
//

import Foundation
import Observation

@Observable class AppState {
    private(set) var currency: Locale.Currency = Locale.current.currency ?? Locale.Currency("EUR")
    private(set) var measurementUnit: UnitLength = Locale.current.measurementSystem == .metric ? .kilometers : .miles
    private(set) var volumeUnit: UnitVolume = Locale.current.measurementSystem == .metric ? .liters : .gallons
    private(set) var currentTheme: ThemeColors

    init() {
        if let currentTheme = ThemeColors.retrieveFromUserDefaults() {
            self.currentTheme = currentTheme
        } else {
            currentTheme = .amethystDrive
        }
    }

    func setCurrentTheme(_ theme: ThemeColors) {
        currentTheme = theme
        ThemeColors.saveToUserDefaults(theme)
    }

    func setMeasurementUnit(_ unit: UnitLength) {
        measurementUnit = unit
    }

    func setVolumeUnit(_ unit: UnitVolume) {
        volumeUnit = unit
    }
}
