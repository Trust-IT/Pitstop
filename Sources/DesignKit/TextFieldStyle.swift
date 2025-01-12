//
//  TextFieldStyle.swift
//  Pitstop
//
//  Created by Ivan Voloshchuk on 12/01/25.
//

import SwiftUI

struct InputTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(Typography.headerXXL)
            .foregroundColor(Palette.black)
    }
}
