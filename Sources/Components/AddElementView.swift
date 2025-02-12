//
//  AddElementView.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 12/02/25.
//

import SwiftUI

struct AddElementView: View {
    let label: String

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Image(.plus)
                .foregroundColor(Palette.greyMiddle)
            Text(label)
                .foregroundColor(Palette.greyMiddle)
                .font(Typography.ControlS)
                .lineLimit(0)
                .frame(width: 128)
        }
        .frame(height: 100)
        .background(
            Rectangle()
                .cornerRadius(8)
                .foregroundColor(Palette.white)
                .shadowGrey()
        )
    }
}

#Preview {
    HStack {
        Spacer()
        AddElementView(label: "Add document")
        AddElementView(label: "Add contact")
        Spacer()
    }
    .frame(maxWidth: .infinity)
    .background(Color.black)
}
