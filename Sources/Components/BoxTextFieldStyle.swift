//
//  BoxTextFieldStyle.swift
//  Pitstop
//
//  Created by Ivan Voloshchuk on 16/01/25.
//

import SwiftUI

struct BoxTextFieldStyle<Field: Hashable>: TextFieldStyle {
    @FocusState.Binding var focusedField: Field?
    let field: Field

    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .disableAutocorrection(true)
            .focused($focusedField, equals: field)
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
            .frame(height: 50)
            .background(focusedField == field ? Palette.greyLight : Palette.greyBackground)
            .font(Typography.TextM)
            .foregroundColor(Palette.black)
            .cornerRadius(36)
            .overlay(
                RoundedRectangle(cornerRadius: 36)
                    .stroke(focusedField == field ? Palette.black : Palette.greyInput, lineWidth: 1)
            )
    }
}

#Preview {
    @Previewable @State var text: String = ""
    @Previewable @FocusState var focusedField: Int?

    TextField("Test", text: $text)
        .textFieldStyle(BoxTextFieldStyle(focusedField: $focusedField, field: 1))
}
