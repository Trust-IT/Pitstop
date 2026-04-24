//
//  ColorHexExt.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 05/05/22.
//

import SwiftUI

extension Color {
    init(rgb: UInt32) {
        self.init(UIColor(rgb: rgb))
    }

    init(lightRGB: UInt32, darkRGB: UInt32) {
        self.init(UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                UIColor(rgb: darkRGB)
            } else {
                UIColor(rgb: lightRGB)
            }
        })
    }
}

extension Color {
    static var random: Color {
        Color(
            red: .random(in: 0 ... 1),
            green: .random(in: 0 ... 1),
            blue: .random(in: 0 ... 1)
        )
    }
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }

    public convenience init(rgb: UInt32, alpha: CGFloat = 1) {
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255
        let blue = CGFloat(rgb & 0x0000FF) / 255
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    var color: Color {
        .init(self)
    }
}

extension Color {
    var uiColor: UIColor {
        .init(self)
    }
}
