//
//  DocumentCell.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 25/12/24.
//

import SwiftUI

struct DocumentCell: View {
    let title: String
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 0) {
                ZStack {
                    Circle()
                        .frame(width: 24, height: 24)
                        .foregroundColor(Palette.greyLight)
                    Image("documents")
                        .resizable()
                        .frame(width: 14, height: 14)
                        .foregroundColor(Palette.black)
                }
                Spacer()
                Text(title)
                    .frame(width: UIScreen.main.bounds.width * 0.33,
                           height: UIScreen.main.bounds.height * 0.03,
                           alignment: .leading)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: false)
                    .foregroundColor(Palette.black)
                    .font(Typography.ControlS)
            }
            .padding(8)
//            .padding()
//            .frame(
//                width: UIScreen.main.bounds.width * 0.38,
//                height: UIScreen.main.bounds.height * 0.13
//            )
            .background {
                Rectangle()
                    .cornerRadius(8)
                    .foregroundColor(Palette.white)
                    .shadowGrey()
            }
            .frame(minHeight: 96)
        }
    }
}

#Preview {
    DocumentCell(title: "Document", onTap: {})
        .background(Color.red)
}
