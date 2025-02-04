//
//  ConfirmationDialog.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 06/01/25.
//

import SwiftUI

// TODO: Fix cell opacity when tapping on it
struct ConfirmationDialog<T>: View where
    T: Hashable & CaseIterable & RawRepresentable & Identifiable,
    T.RawValue == String {
    let items: [T]
    let message: String
    let onTap: (T) -> Void
    let onCancel: () -> Void

    init(
        items: [T] = [],
        message: String,
        onTap: @escaping (T) -> Void,
        onCancel: @escaping () -> Void
    ) {
        if items.isEmpty {
            self.items = Array(T.allCases)
        } else {
            self.items = items
        }
        self.message = message
        self.onTap = onTap
        self.onCancel = onCancel
    }

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            VStack(spacing: 0) {
                Text(message)
                    .multilineTextAlignment(.center)
                    .font(Typography.TextM)
                    .foregroundStyle(Palette.greyHard)
                    .frame(maxWidth: .infinity, idealHeight: 42)
                    .padding(10)
                    .background(Palette.greyInput)
                VStack(spacing: 0) {
                    ForEach(items) { item in
                        Button(action: {
                            onTap(item)
                        }, label: {
                            dialogCell(title: item.rawValue.capitalized)
                        })
                        .buttonStyle(.plain)
                    }
                }
            }
            .clipShape(
                UnevenRoundedRectangle(
                    cornerRadii: .init(
                        topLeading: 13,
                        bottomLeading: 13,
                        bottomTrailing: 13,
                        topTrailing: 13
                    ),
                    style: .continuous
                )
            )
            .padding(.horizontal, 16)

            Button(PitstopAPPStrings.Common.cancel) {
                onCancel()
            }
            .buttonStyle(Primary(height: 58, cornerRadius: 13))
            .padding(.top, 8)
        }
    }

    @ViewBuilder
    private func dialogCell(title: String) -> some View {
        VStack(spacing: 0) {
            Text(title)
                .font(Typography.headerM)
                .foregroundStyle(Palette.black)
                .frame(maxWidth: .infinity, maxHeight: 58)
                .background(Palette.greyLight)
            Divider()
        }
    }
}

#Preview {
    ConfirmationDialog(
        items: FuelType.allCases,
        message: "Select fuel type",
        onTap: { _ in },
        onCancel: {}
    )
    .background(.gray)
}
