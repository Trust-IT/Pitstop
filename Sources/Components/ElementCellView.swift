//
//  ElementCellView.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 25/12/24.
//

import SwiftUI

struct ElementCellView: View {
    let title: String
    let subtitle: String?
    let icon: ImageResource

    init(title: String, subtitle: String? = nil, icon: ImageResource) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack {
                Circle()
                    .frame(width: 24, height: 24)
                    .foregroundColor(Palette.greyLight)
                Image(icon)
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
        ElementCellView(title: "Document", icon: .documents)
        ElementCellView(title: "Contacts", subtitle: "39223012", icon: .wrench)
    }
    .background(Color.red)
}
