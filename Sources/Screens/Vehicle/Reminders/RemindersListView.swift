//
//  RemindersListView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 03/06/22.
//

import SwiftData
import SwiftUI

struct RemindersListView: View {
    @EnvironmentObject var navManager: NavigationManager
    @Environment(\.modelContext) private var modelContext

    static var currentDate: Date { Date.now }

    @Query(
        filter: #Predicate<Reminder> { $0.date >= currentDate },
        sort: [SortDescriptor(\Reminder.date, order: .forward)]
    )
    var reminders: [Reminder]

    @Query(
        filter: #Predicate<Reminder> { $0.date < currentDate },
        sort: [SortDescriptor(\Reminder.date, order: .forward)]
    )
    var expiredReminders: [Reminder]
    @State var selectedReminder: Reminder = .mock()

    var body: some View {
        NavigationView {
            ZStack {
                Palette.greyBackground
                    .ignoresSafeArea()
                VStack {
                    ScrollView(.vertical, showsIndicators: false) {
                        reminderSection(
                            title: "Future",
                            items: reminders,
                            areItemsExpired: false,
                            onItemTap: { reminder in
                                // TODO: Simplify this
                                selectedReminder = reminder
                                navManager.push(.editReminder(input: $selectedReminder))
                            }
                        )

                        reminderSection(
                            title: "Expired",
                            items: expiredReminders,
                            areItemsExpired: true,
                            onItemTap: { reminder in
                                // TODO: Simplify this
                                selectedReminder = reminder
                                navManager.push(.expiredReminder(input: $selectedReminder))
                            }
                        )
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(PitstopAPPStrings.Common.cancel) {
                        navManager.pop()
                    }
                    .font(Typography.headerM)
                    .foregroundColor(Palette.greyHard)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    if !expiredReminders.isEmpty {
                        Button("Clear expired") {
                            deleteExpiredReminders()
                        }
                        .font(Typography.headerM)
                        .foregroundColor(Palette.greyHard)
                    }
                }

                ToolbarItem(placement: .principal) {
                    Text("Reminders")
                        .font(Typography.headerM)
                        .foregroundColor(Palette.black)
                }
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
                    Text("There are no reminders now")
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
                        .foregroundColor(expired ? Palette.greyInput : item.category.color)
                    Image(item.category.icon)
                        .resizable()
                        .saturation(expired ? 0 : 1)
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
        for reminder in expiredReminders {
            modelContext.delete(reminder)
        }

        do {
            try modelContext.save()
        } catch {
            print("Failed to delete reminders: \(error)")
        }
    }
}

// FIXME: Preview

// struct RemindersList_Previews: PreviewProvider {
//    static var previews: some View {
//        RemindersList()
//    }
// }
