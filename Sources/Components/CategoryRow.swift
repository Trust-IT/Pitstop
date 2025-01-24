//
//  CategoryRow.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 19/05/23.
//

import SwiftUI

struct CategoryRow: View {
    @Environment(AppState.self) var appState: AppState
    var input: CategoryRow.Input

    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .frame(width: 32, height: 32)
                    .foregroundColor(input.color)
                Image(input.icon)
                    .resizable()
                    .frame(width: 16, height: 16)
                    .tint(appState.currentTheme.accentColor)
            }
            Text(input.title)
                .font(Typography.headerM)
        }
    }

    struct Input {
        var title: String
        var icon: ImageResource
        var color: Color
    }
}
