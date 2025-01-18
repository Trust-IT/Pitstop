//
//  AppState.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 06/05/22.
//

import Foundation
import Observation

@Observable class AppState {
    private(set) var currency = "€"
    private(set) var unit = "km"
    private(set) var currentTheme: ThemeColors

    /// Checks if vehicle is added from the flow in settings
    private(set) var isAddingNewVehicle: Bool = false

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

    func setAddingNewVehicle(_ value: Bool) {
        isAddingNewVehicle = value
    }
}
