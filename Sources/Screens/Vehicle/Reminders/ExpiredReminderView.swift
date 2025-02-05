//
//  ExpiredReminderView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 11/06/22.
//

import SwiftUI

struct ExpiredReminderView: View {
    @EnvironmentObject var navManager: NavigationManager
    @Binding var reminder: Reminder

    var body: some View {
        VStack {
            reminderInformation()
                .disabled(true)
        }
        .background(Palette.greyBackground)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(reminder.title)
                    .font(Typography.headerM)
                    .foregroundColor(Palette.black)
            }
        }
    }

    @ViewBuilder
    private func reminderInformation() -> some View {
        CustomList {
            HStack {
                CategoryRow(input: .init(
                    title: String(localized: "Title"),
                    icon: .other,
                    color: Palette.colorViolet
                ))

                Spacer()
                Text(reminder.title)
                    .font(Typography.headerM)
                    .foregroundColor(Palette.greyMiddle)
                    .fixedSize(horizontal: true, vertical: true)
            }
            .contentShape(Rectangle())
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))

            // MARK: - CATEGORY

            HStack {
                CategoryRow(input: .init(
                    title: String(localized: "Category"),
                    icon: .category,
                    color: Palette.colorYellow
                ))

                Spacer()
                Text(reminder.category.rawValue)
                    .font(Typography.headerM)
                    .foregroundColor(Palette.greyMiddle)
                    .fixedSize(horizontal: true, vertical: true)
            }
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))

            // MARK: - DATE

            HStack {
                CategoryRow(input: .init(
                    title: String(localized: "Day"),
                    icon: .day,
                    color: Palette.colorGreen
                ))

                Spacer()
                Text(reminder.date.formatDate(with: "MMM d HH:mm"))
                    .font(Typography.headerM)
                    .foregroundColor(Palette.greyMiddle)
                    .fixedSize(horizontal: true, vertical: true)
            }
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))

            // MARK: - NOTE

            HStack {
                CategoryRow(input: .init(
                    title: String(localized: "Note"),
                    icon: .note,
                    color: Palette.colorViolet
                ))
                Spacer()
                Text(reminder.note)
                    .font(Typography.headerM)
                    .foregroundColor(Palette.greyMiddle)
                    .fixedSize(horizontal: true, vertical: true)
            }
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
        }
    }
}

#Preview {
    ExpiredReminderView(reminder: .constant(.mock()))
}
