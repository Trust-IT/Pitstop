//
//  FuelInputTextField.swift
//  Pitstop
//
//  Created by Ivan Voloshchuk on 24/01/25.
//

import SwiftUI

struct FuelInputTextField: View {
    @Environment(AppState.self) var appState: AppState

    let title: String
    let placeholder: String
    let measurement: String
    let icon: ImageResource
    @FocusState.Binding var focusState: FuelInputFocusField?
    let focus: FuelInputFocusField
    @Binding var text: String
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .foregroundStyle(Palette.black)
                .font(Typography.headerM)
                .padding(.horizontal, 12)
            HStack {
                ZStack {
                    Circle()
                        .fill(text.isEmpty ? Palette.greyLight : appState.currentTheme.colors.background)
                        .frame(width: 32, height: 32)
                    Image(icon)
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(text.isEmpty ? Palette.greyInput : appState.currentTheme.accentColor)
                }
                TextField(placeholder, text: $text)
                    .foregroundStyle(Palette.black)
                    .font(Typography.headerM)
                    .padding(.leading, 12)
                    .keyboardType(.decimalPad)
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
