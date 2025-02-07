//
//  DeleteButton.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 23/05/23.
//

import SwiftUI

struct DeleteButton: View {
    let title: String

    var body: some View {
        HStack {
            Spacer()
            Image(.deleteIcon)
                .resizable()
                .foregroundColor(Palette.white)
                .frame(width: 14, height: 14)
            Text(title)
            Spacer()
        }
    }
}
