//
//  DeleteButton.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 23/05/23.
//

import ChassisUI
import SwiftUI

public struct DeleteButton: View {
    let title: String

    public var body: some View {
        HStack {
            Spacer()
            ChassisUIAsset.deleteIcon.swiftUIImage
                .resizable()
                .foregroundColor(Palette.white)
                .frame(width: 14, height: 14)
            Text(title)
            Spacer()
        }
    }
}
