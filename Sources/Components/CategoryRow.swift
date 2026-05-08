//
//  CategoryRow.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 19/05/23.
//

import ChassisUI
import SwiftUI

public struct CategoryRow: View {
    @Environment(AppState.self) var appState: AppState
    var input: CategoryRow.Input

    public var body: some View {
        HStack {
            ZStack {
                Circle()
                    .frame(width: 32, height: 32)
                    .foregroundStyle(input.isDisabled ? Palette.greyLight : input.color)
                input.icon.swiftUIImage
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foregroundStyle(input.isDisabled ? Palette.greyInput : appState.currentTheme.accentColor)
            }
            Text(input.title)
                .font(Typography.headerM)
        }
    }

    struct Input {
        var title: String
        var icon: ChassisUIImages
        var color: Color
        var isDisabled: Bool = false
    }
}
