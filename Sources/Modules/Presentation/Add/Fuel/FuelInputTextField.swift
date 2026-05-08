//
//  FuelInputTextField.swift
//  Pitstop
//
//  Created by Ivan Voloshchuk on 24/01/25.
//

import ChassisUI
import SwiftUI

struct FuelInputTextField<V: Comparable & AdditiveArithmetic, F: ParseableFormatStyle>: View
    where F.FormatInput == V, F.FormatOutput == String {
    @Environment(AppState.self) var appState: AppState

    let title: String
    let placeholder: String
    let measurement: String
    let icon: ChassisUIImages
    @FocusState.Binding var focusState: FuelInputFocusField?
    let focus: FuelInputFocusField
    @Binding var value: V
    let format: F
    var keyboardType: UIKeyboardType = .decimalPad

    private var isEmpty: Bool { value == .zero }

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .foregroundStyle(Palette.black)
                .font(Typography.headerM)
                .padding(.horizontal, 12)
            HStack {
                ZStack {
                    Circle()
                        .fill(isEmpty ? Palette.greyLight : appState.currentTheme.colors.background)
                        .frame(width: 32, height: 32)
                    icon.swiftUIImage
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(isEmpty ? Palette.greyInput : appState.currentTheme.accentColor)
                }
                TextField(placeholder, value: $value, format: format)
                    .foregroundStyle(Palette.black)
                    .font(Typography.headerM)
                    .padding(.leading, 12)
                    .keyboardType(keyboardType)
                    .focused($focusState, equals: focus)
                Spacer()
                Text(measurement)
                    .foregroundStyle(Palette.black)
                    .font(Typography.headerM)
            }
            .padding(.horizontal, 12)
            .frame(height: 54)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Palette.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(focusState == focus ? Palette.black : Palette.white, lineWidth: 1)
                    )
            )
        }
        .padding(.horizontal, 12)
        .background(Palette.greyBackground)
    }
}

enum FuelInputFocusField: Hashable {
    case totalPrice
    case odometer
    case quantity
}
