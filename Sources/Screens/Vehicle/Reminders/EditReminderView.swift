//
//  EditReminderView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 10/06/22.
//

import SwiftUI

struct EditReminderView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.presentationMode) private var presentationMode

    @FocusState var focusedField: FocusFieldReminder?
    @State private var showDeleteAlert = false
    @State private var category: ServiceCategory
    @State private var title: String
    @State private var date: Date
    @State private var note: String

    var reminder: Reminder

    init(reminder: Binding<Reminder>) {
        self.reminder = reminder.wrappedValue
        _category = State(initialValue: reminder.wrappedValue.category)
        _date = State(initialValue: reminder.wrappedValue.date)
        _title = State(initialValue: reminder.wrappedValue.title)
        _note = State(initialValue: reminder.wrappedValue.note)
    }

    enum FocusFieldReminder: Hashable {
        case title
        case note
    }

    var body: some View {
        VStack {
            reminderInformation()
        }
        .background(Palette.greyBackground)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(
            leading:
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                HStack {
                    Image("arrowLeft")

                    Text(String(localized: "Back"))
                        .font(Typography.headerM)
                }
            })
            .accentColor(Palette.greyHard),
            trailing:
            Button(action: {
                updateReminder(reminder)
                createNotification(from: reminder)
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text(PitstopAPPStrings.Common.save)
                    .font(Typography.headerM)
            })
        )
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(String(localized: "Edit reminder"))
                    .font(Typography.headerM)
                    .foregroundColor(Palette.black)
            }
        }
        .overlay(
            VStack {
                Spacer(minLength: UIScreen.main.bounds.size.height * 0.78)
                Button(action: {
                    showDeleteAlert.toggle()
                }, label: {
                    DeleteButton(title: "Delete reminder")
                })
                .buttonStyle(Primary())
                Spacer()
            }
        )
        .alert(isPresented: $showDeleteAlert) {
            Alert(
                title: Text(String(localized: "Are you sure you want to delete this reminder?")),
                message: Text(String(localized: "This action cannot be undone")),
                primaryButton: .destructive(Text(String(localized: "Delete"))) {
                    removeNotification(for: reminder)
                    deleteReminder(reminder)
                    presentationMode.wrappedValue.dismiss()
                },
                secondaryButton: .cancel()
            )
        }
    }
}

private extension EditReminderView {
    func reminderInformation() -> some View {
        CustomList {
            HStack {
                CategoryRow(input: .init(
                    title: String(localized: "Title"),
                    icon: .other,
                    color: Palette.colorViolet
                ))
                Spacer()
                TextField(String(localized: "Title"), text: $title)
                    .font(Typography.headerM)
                    .foregroundColor(Palette.black)
                    .focused($focusedField, equals: .title)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                focusedField = .title
            }
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))

            // MARK: - CATEGORY

            HStack {
                CategoryRow(input: .init(
                    title: String(localized: "Category"),
                    icon: .category,
                    color: Palette.colorYellow
                ))
                NavigationLink(destination:
                    CategoryPicker(selectedCategory: $category)) {
                        Spacer()
                        Text(category.rawValue)
                            .font(Typography.headerM)
                            .foregroundColor(Palette.greyMiddle)
                    }
            }
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))

            // MARK: - DATE

            DatePicker(selection: $date, in: Date() ... Date().addingYears(3)!) {
                CategoryRow(input: .init(
                    title: String(localized: "Day"),
                    icon: .day,
                    color: Palette.colorGreen
                ))
            }
            .datePickerStyle(.compact)
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))

            // MARK: - NOTE

            HStack {
                CategoryRow(input: .init(
                    title: String(localized: "Note"),
                    icon: .note,
                    color: Palette.colorViolet
                ))
                Spacer()
                TextField(String(localized: "Note"), text: $note)
                    .font(Typography.headerM)
                    .foregroundColor(Palette.black)
                    .focused($focusedField, equals: .note)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                focusedField = .note
            }
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
        }
    }
}

private extension EditReminderView {
    func deleteReminder(_ reminder: Reminder) {
        modelContext.delete(reminder)
        do {
            try modelContext.save()
        } catch {
            print("Failed to delete reminder: \(error)")
        }
    }

    func updateReminder(_ reminder: Reminder) {
        reminder.title = title
        reminder.category = category
        reminder.note = note
        reminder.date = date
        do {
            try modelContext.save()
            print("Reminder saved successfully!")
        } catch {
            print("Failed to save reminder: \(error)")
        }
    }

    func createNotification(from reminder: Reminder) {
        let inputData = ReminderNotificationData(from: reminder)
        Task {
            await NotificationManager.shared.removeNotification(for: inputData)
            await NotificationManager.shared.createNotification(for: inputData)
        }
    }

    func removeNotification(for reminder: Reminder) {
        let inputData = ReminderNotificationData(from: reminder)
        Task {
            await NotificationManager.shared.removeNotification(for: inputData)
        }
    }
}

#Preview {
    EditReminderView(reminder: .constant(.mock()))
}
