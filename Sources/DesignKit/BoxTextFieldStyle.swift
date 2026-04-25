//
//  BoxTextFieldStyle.swift
//  Pitstop
//
//  Created by Ivan Voloshchuk on 16/01/25.
//

import SwiftUI

struct BoxFieldModifier<Field: Hashable>: ViewModifier {
    @FocusState.Binding var focusedField: Field?
    let field: Field

    private let radius: CGFloat = 36

    func body(content: Content) -> some View {
        content
            .autocorrectionDisabled()
            .focused($focusedField, equals: field)
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
            .frame(height: 50)
            .background(focusedField == field ? Palette.greyLight : Palette.greyBackground)
            .font(Typography.TextM)
            .foregroundColor(Palette.black)
            .clipShape(RoundedRectangle(cornerRadius: radius))
            .overlay(
                RoundedRectangle(cornerRadius: radius)
                    .stroke(focusedField == field ? Palette.black : Palette.greyInput, lineWidth: 1)
            )
    }
}

extension View {
    func boxFieldStyle<F: Hashable>(focusedField: FocusState<F?>.Binding, field: F) -> some View {
        modifier(BoxFieldModifier(focusedField: focusedField, field: field))
    }
}

#Preview {
    @Previewable @State var text = ""
    @Previewable @FocusState var focusedField: Int?

    TextField("Test", text: $text)
        .boxFieldStyle(focusedField: $focusedField, field: 1)
}
