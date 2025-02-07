//
//  ExpiredReminderView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 11/06/22.
//

import SwiftData
import SwiftUI

struct ExpiredReminderView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var navManager: NavigationManager
    let reminder: Reminder

    var body: some View {
        VStack {
            reminderInformation()
                .disabled(true)
            Spacer()
            Button(action: {
                deleteReminder(reminder)
                navManager.pop()
            }, label: {
                DeleteButton(title: PitstopAPPStrings.Reminder.clear)
            })
            .buttonStyle(Primary())
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
                    title: PitstopAPPStrings.Common.title,
                    icon: .other,
                    color: Palette.colorViolet,
                    isDisabled: true
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
                    title: PitstopAPPStrings.Common.category,
                    icon: .category,
                    color: Palette.colorYellow,
                    isDisabled: true
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
                    title: PitstopAPPStrings.Common.day,
                    icon: .day,
                    color: Palette.colorGreen,
                    isDisabled: true
                ))

                Spacer()
                Text(reminder.date.formatDate(with: "MMM d HH:mm"))
                    .font(Typography.headerM)
                    .foregroundColor(Palette.greyMiddle)
                    .fixedSize(horizontal: true, vertical: true)
            }
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))

            // MARK: - NOTE

            if !reminder.note.isEmpty {
                HStack {
                    CategoryRow(input: .init(
                        title: PitstopAPPStrings.Common.note,
                        icon: .note,
                        color: Palette.colorViolet,
                        isDisabled: true
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
}

private extension ExpiredReminderView {
    func deleteReminder(_ reminder: Reminder) {
        modelContext.delete(reminder)
        do {
            try modelContext.save()
        } catch {
            print("Failed to delete reminder: \(error)")
        }
    }
}

#Preview {
    ExpiredReminderView(reminder: .mock())
}
