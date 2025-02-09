//
//  AlertInputView.swift
//  Pitstop
//
//  Created by Ivan Voloshchuk on 09/02/25.
//

import SwiftUI

struct AlertInputView: View {
    @FocusState private var focusState: AlertInputFocus?
    @State private var input: String = ""

    let title: String
    let placeholder: String
    @Binding var alert: AlertConfig
    let action: (String) -> Void

    var body: some View {
        VStack(spacing: 25) {
            HStack {
                Spacer()
                Text(title)
                    .foregroundColor(Palette.black)
                    .font(Typography.headerM)
                    .padding(.leading, 40)
                Spacer()
                Button(action: {
                    alert.dismiss()
                }, label: {
                    ZStack {
                        Circle()
                            .frame(width: 24, height: 24)
                            .foregroundColor(Palette.greyLight)
                        Image(.ics)
                            .foregroundColor(Palette.black)
                    }
                    .padding(.trailing, 20)
                })
            }
            VStack(spacing: 12) {
                TextField(placeholder, text: $input)
                    .textFieldStyle(BoxTextFieldStyle(focusedField: $focusState, field: .input))
                    .padding(.horizontal, 16)
                Button(PitstopAPPStrings.Common.save) {
                    action(input)
                    alert.dismiss()
                }
                .buttonStyle(Primary())
                .disabled(input.isEmpty)
            }
        }
        .padding(.vertical, 26)
        .background(Rectangle()
            .cornerRadius(18)
            .foregroundColor(Palette.white))
        .padding()
        .onAppear { focusState = .input }
    }

    private enum AlertInputFocus: Hashable {
        case input
    }
}

#Preview {
    VStack {
        Spacer()
        AlertInputView(
            title: "Default",
            placeholder: "Text",
            alert: .constant(.init()),
            action: { _ in
            }
        )
        Spacer()
    }
    .frame(maxWidth: .infinity)
    .background(Color.gray)
}
