//
//  ExpiredReminderView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 11/06/22.
//

import ChassisUI
import NavigatorUI
import PitstopData
import SwiftUI

struct ExpiredReminderView: View {
    @Environment(VehicleManager.self) private var vehicleManager: VehicleManager
    @Environment(\.navigator) var navigator
    let reminder: Reminder

    var body: some View {
        VStack {
            reminderInformation()
                .disabled(true)
            Spacer()
            Button(action: {
                vehicleManager.deleteReminder(reminder)
                navigator.back()
            }, label: {
                DeleteButton(title: PitstopStrings.Localizable.Reminder.clear)
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
                    title: PitstopStrings.Localizable.Common.title,
                    icon: ChassisUIAsset.other,
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
                    title: PitstopStrings.Localizable.Common.category,
                    icon: ChassisUIAsset.category,
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
                    title: PitstopStrings.Localizable.Common.day,
                    icon: ChassisUIAsset.day,
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
                        title: PitstopStrings.Localizable.Common.note,
                        icon: ChassisUIAsset.note,
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

#Preview {
    ExpiredReminderView(reminder: .mock())
}
