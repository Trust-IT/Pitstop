//
//  RemindersListView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 03/06/22.
//

import ChassisUI
import NavigatorUI
import PitstopData
import SwiftUI

struct RemindersListView: View {
    @Environment(\.navigator) var navigator
    @Environment(VehicleManager.self) private var vehicleManager: VehicleManager

    private var reminders: [Reminder] { vehicleManager.currentReminders }
    private var expiredReminders: [Reminder] { vehicleManager.expiredReminders }

    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                reminderSection(
                    title: PitstopStrings.Localizable.Common.future,
                    items: reminders,
                    areItemsExpired: false,
                    onItemTap: { reminder in
                        navigator.navigate(to: VehicleDestinations.reminderReport(input: reminder, isEdit: true))
                    }
                )

                reminderSection(
                    title: PitstopStrings.Localizable.Common.expired,
                    items: expiredReminders,
                    areItemsExpired: true,
                    onItemTap: { reminder in
                        navigator.navigate(to: VehicleDestinations.expiredReminder(input: reminder))
                    }
                )
            }
            .padding(.top, 16)
            if !expiredReminders.isEmpty {
                Button(action: {
                    deleteExpiredReminders()
                }, label: {
                    DeleteButton(title: PitstopStrings.Localizable.Reminder.clearAll)
                })
                .buttonStyle(Primary())
            }
        }
        .background(Palette.greyBackground.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(PitstopStrings.Localizable.Reminder.title)
                    .font(Typography.headerM)
                    .foregroundColor(Palette.black)
            }
            ToolbarItem(placement: .navigation) {
                Button(action: {
                    navigator.dismiss()
                }, label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Palette.black)
                })
            }
        }
    }
}

private extension RemindersListView {
    @ViewBuilder
    func reminderSection(
        title: String,
        items: [Reminder],
        areItemsExpired: Bool,
        onItemTap: @escaping (Reminder) -> Void
    ) -> some View {
        VStack {
            ZStack {
                Rectangle()
                    .frame(height: UIScreen.main.bounds.height * 0.035)
                    .foregroundColor(Palette.greyLight)
                HStack {
                    Text(title)
                        .foregroundColor(Palette.black)
                        .font(Typography.ControlS)
                    Spacer()
                }
                .padding()
            }
            if items.isEmpty {
                HStack {
                    Text(PitstopStrings.Localizable.Reminder.empty)
                        .font(Typography.TextM)
                        .foregroundColor(Palette.greyMiddle)
                    Spacer()
                }
                .padding()
            } else {
                ForEach(items, id: \.uuid) { reminder in
                    reminderRow(item: reminder, expired: areItemsExpired) { currentReminder in
                        onItemTap(currentReminder)
                    }
                }
            }
        }
    }

    @ViewBuilder
    func reminderRow(
        item: Reminder,
        expired: Bool,
        ontap: @escaping (Reminder) -> Void
    ) -> some View {
        Button(action: { ontap(item) }, label: {
            HStack {
                ZStack {
                    Circle()
                        .frame(width: 32, height: 32)
                        .foregroundColor(expired ? Palette.greyLight : Palette.colorOrange)
                    item.category.icon.swiftUIImage
                        .resizable()
                        .tint(expired ? Palette.greyInput : Palette.orangeAccent)
                        .frame(width: 16, height: 16)
                }
                VStack(alignment: .leading) {
                    HStack {
                        Text(item.title)
                            .foregroundColor(expired ? Palette.greyMiddle : Palette.black)
                            .font(Typography.headerS)
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                        Spacer()

                        Text(item.date.toString(dateFormat: "MMM d, EEEE"))
                            .foregroundColor(expired ? Palette.greyMiddle : Palette.greyHard)
                            .font(Typography.headerS)
                            .padding(.trailing, -10)
                    }
                    Text(item.category.rawValue)
                        .foregroundColor(Palette.greyMiddle)
                        .font(Typography.TextM)
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
        })
    }
}

private extension RemindersListView {
    func deleteExpiredReminders() {
        vehicleManager.deleteAllExpiredReminders()
    }
}

#Preview {
    @Previewable @State var vehicleManager = PreviewSupport.vehicleManager
    ManagedNavigationStack {
        RemindersListView()
            .environment(vehicleManager)
            .environment(AppState())
    }
}
