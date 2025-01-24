//
//  Palette.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 05/05/22.
//

import SwiftUI

enum Palette {
    static let white = Color(lightRGB: 0xFFFFFF, darkRGB: 0x1E1E1E)
    static let black = Color(lightRGB: 0x0B0B0B, darkRGB: 0xF9F9F9)

    static let blackHeader = Color(rgb: 0x1E1E1E)
    static let whiteHeader = Color(rgb: 0xFFFFFF)

    static let colorViolet = Color(rgb: 0xC6B3FF)
    static let colorGreen = Color(rgb: 0x8BE8BD)
    static let colorYellow = Color(rgb: 0xFFEE96)
    static let colorBlue = Color(rgb: 0x97F1EC)
    static let colorOrange = Color(rgb: 0xF2C888)

    static let greyHard = Color(lightRGB: 0x616161, darkRGB: 0xA9A9A9)
    static let greyMiddle = Color(lightRGB: 0x8A8A8A, darkRGB: 0x6F6F6F)
    static let greyInput = Color(lightRGB: 0xD2D2D2, darkRGB: 0x2D2D2D)
    static let greyLight = Color(lightRGB: 0xF5F5F5, darkRGB: 0x363636)
    static let greyEBEBEB = Color(lightRGB: 0xEBEBEB, darkRGB: 0x353535)
    static let greyBackground = Color(lightRGB: 0xFBFBFB, darkRGB: 0x121212)

    static let colorVioletLight = Color(rgb: 0x94BCF8)
 
    // Accent:
    static let violetAccent = Color(rgb: 0x9A7EFF)
    static let greenAccent = Color(rgb: 0x4CD38C)
    static let yellowAccent = Color(rgb: 0xE8CA51)
    static let blueAccent = Color(rgb: 0x59E4DA)
    
    static let colorMainBlue = Color(rgb: 0x9FFCF7)
    static let colorMainGreen = Color(rgb: 0x94F3C7)
    static let colorMainYellow = Color(rgb: 0xFBE989)
    static let colorMainViolet = Color(rgb: 0xCDBCFF)
    static let greenHighlight = Color(rgb: 0x37E391)
    static let blueLine = Color(rgb: 0x4761FE)

    // Chart:
    static let chartGreen = Color(rgb: 0xA1DEC0)
}

extension View {
    func shadowGrey() -> some View {
        shadow(color: .black.opacity(0.04), radius: 10, x: 1, y: 2)
    }
}
