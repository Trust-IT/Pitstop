//
//  TextFieldStyle.swift
//  Pitstop
//
//  Created by Ivan Voloshchuk on 12/01/25.
//

import SwiftUI

public struct InputTextFieldStyle: TextFieldStyle {
    public init() {}

    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(Typography.headerXXL)
            .foregroundColor(Palette.black)
    }
}
