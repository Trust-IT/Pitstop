//
//  ElementCellView.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 25/12/24.
//

import ChassisUI
import SwiftUI

public struct ElementCellView: View {
    let title: String
    let subtitle: String?
    let icon: ChassisUIImages

    public init(title: String, subtitle: String? = nil, icon: ChassisUIImages) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack {
                Circle()
                    .frame(width: 24, height: 24)
                    .foregroundColor(Palette.greyLight)
                icon.swiftUIImage
                    .resizable()
                    .frame(width: 14, height: 14)
                    .foregroundColor(Palette.black)
            }
            Spacer()
            Text(title)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: false)
                .foregroundColor(Palette.black)
                .font(Typography.ControlS)
            if let subtitle {
                Text(subtitle)
                    .foregroundColor(Palette.greyMiddle)
                    .font(Typography.TextM)
                    .lineLimit(1)
            }
        }
        .padding(8)
        .frame(width: 128, height: 100, alignment: .leading)
        .background {
            Rectangle()
                .cornerRadius(8)
                .foregroundColor(Palette.white)
                .shadowGrey()
        }
    }
}

#Preview {
    VStack {
        ElementCellView(title: "Document", icon: ChassisUIAsset.documents)
        ElementCellView(title: "Contacts", subtitle: "39223012", icon: ChassisUIAsset.wrench)
    }
    .background(Color.red)
}
