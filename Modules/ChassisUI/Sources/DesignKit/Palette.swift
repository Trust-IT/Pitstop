//
//  Palette.swift
//  ChassisUI
//

import SwiftUI

public enum Palette {
    public static let white = Color(lightRGB: 0xFFFFFF, darkRGB: 0x1E1E1E)
    public static let black = Color(lightRGB: 0x0B0B0B, darkRGB: 0xF9F9F9)

    public static let blackHeader = Color(rgb: 0x1E1E1E)
    public static let whiteHeader = Color(rgb: 0xFFFFFF)

    public static let colorViolet = Color(rgb: 0xC6B3FF)
    public static let colorGreen = Color(rgb: 0x8BE8BD)
    public static let colorYellow = Color(rgb: 0xFFEE96)
    public static let colorBlue = Color(rgb: 0xBEE6FF)
    public static let colorOrange = Color(rgb: 0xF2C888)

    public static let greyHard = Color(lightRGB: 0x616161, darkRGB: 0xA9A9A9)
    public static let greyMiddle = Color(lightRGB: 0x8A8A8A, darkRGB: 0x6F6F6F)
    public static let greyInput = Color(lightRGB: 0xD2D2D2, darkRGB: 0x2D2D2D)
    public static let greyLight = Color(lightRGB: 0xF5F5F5, darkRGB: 0x363636)
    public static let greyEBEBEB = Color(lightRGB: 0xEBEBEB, darkRGB: 0x353535)
    public static let greyBackground = Color(lightRGB: 0xFBFBFB, darkRGB: 0x121212)

    // Accent
    public static let violetAccent = Color(rgb: 0x9A7EFF)
    public static let greenAccent = Color(rgb: 0x4CD38C)
    public static let yellowAccent = Color(rgb: 0xE8CA51)
    public static let blueAccent = Color(rgb: 0x54B2FF)
    public static let orangeAccent = Color(rgb: 0xE59D49)

    public static let colorMainBlue = Color(rgb: 0xADE0FF)
    public static let colorMainGreen = Color(rgb: 0x94F3C7)
    public static let colorMainYellow = Color(rgb: 0xFBE989)
    public static let colorMainViolet = Color(rgb: 0xCDBCFF)

    // Chart
    public static let greenHighlight = Color(rgb: 0x37E391)
    public static let blueLine = Color(rgb: 0x4761FE)
    public static let chartGreen = Color(rgb: 0xA1DEC0)
}

public extension View {
    func shadowGrey() -> some View {
        shadow(color: .black.opacity(0.04), radius: 10, x: 1, y: 2)
    }
}
