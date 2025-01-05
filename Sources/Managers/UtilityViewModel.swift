//
//  UtilityViewModel.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 06/05/22.
//

import Foundation

class UtilityViewModel: ObservableObject {
    @Published var currency = "€"
    @Published var unit = "km"

    @Published var currentTheme: ThemeColors

    init() {
        if let currentTheme = ThemeColors.retrieveFromUserDefaults() {
            self.currentTheme = currentTheme
        } else {
            currentTheme = .amethystDrive
        }
    }
}
