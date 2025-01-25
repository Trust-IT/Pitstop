//
//  Typography.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 05/05/22.
//

import SwiftUI
import UIKit

enum Typography {
    static let headerXXL = Font.system(size: 40, weight: .bold, design: .rounded)
    static let headerXL = Font.system(size: 26, weight: .semibold, design: .rounded)
    static let headerL = Font.system(size: 20, weight: .bold, design: .rounded)
    static let headerM = Font.system(size: 17, weight: .medium, design: .rounded)
    static let headerMS = Font.system(size: 16, weight: .semibold, design: .rounded)
    static let headerS = Font.system(size: 14, weight: .semibold, design: .rounded)
    static let headerXS = Font.system(size: 11.5, weight: .semibold, design: .rounded)
    static let headerLM = Font.system(size: 19, weight: .bold, design: .rounded)

    static let TextM = Font.system(size: 14, weight: .regular, design: .rounded)
    static let ControlS = Font.system(size: 14, weight: .semibold, design: .rounded)
}
