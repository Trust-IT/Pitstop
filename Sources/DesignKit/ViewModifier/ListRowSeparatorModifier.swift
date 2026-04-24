//
//  ListRowSeparatorModifier.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 19/05/23.
//

import SwiftUI

struct ListRowSeparatorModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content
                .listRowSeparatorTint(Palette.greyLight)
                .alignmentGuide(.listRowSeparatorLeading) { _ in
                    0
                }
                .alignmentGuide(.listRowSeparatorTrailing) { viewDimensions in
                    viewDimensions[.listRowSeparatorTrailing] - 5
                }
        } else {
            content
                .listRowSeparatorTint(Palette.greyLight)
        }
    }
}

extension View {
    func setRowSeparatorStyle() -> some View {
        modifier(ListRowSeparatorModifier())
    }
}
