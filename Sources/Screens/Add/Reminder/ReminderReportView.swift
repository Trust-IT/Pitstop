//
//  ReminderReportView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 06/05/22.
//

import SwiftUI

struct ReminderReportView: View {
    @EnvironmentObject var navManager: NavigationManager
    @Environment(AppState.self) var appState: AppState
    @Environment(\.modelContext) private var modelContext

    @State private var showDeleteAlert = false
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""

    @State private var reminder: Reminder
    let isEditMode: Bool

    @FocusState var reminderInputFocus: ReminderInputFocusField?

    init(reminder: Reminder, isEditMode: Bool) {
        _reminder = .init(initialValue: reminder)
        self.isEditMode = isEditMode
    }

    var body: some View {
        VStack {
            HStack {
                Spacer()
                TextField("-", text: $reminder.title)
                    .focused($reminderInputFocus, equals: .reminderTitle)
                    .textFieldStyle(InputTextFieldStyle())
                    .fixedSize(horizontal: true, vertical: true)
                Spacer()
            }
            .padding(.top, 26)

            ReminderInputView(reminder: reminder, reminderInputFocus: $reminderInputFocus)

            Button(PitstopAPPStrings.Common.save) {
                createReminderNotification()
            }
            .buttonStyle(Primary())
            .disabled(reminder.title.isEmpty)
        }
        .background(Palette.greyBackground)
        .navigationTitle(PitstopAPPStrings.Reminder.new)
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: {
                    navManager.pop()
                }, label: {
                    Image(.arrowLeft)
                        .resizable()
                        .frame(width: 12, height: 16)
                        .tint(Palette.black)
                })
            }

            if isEditMode {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        showDeleteAlert.toggle()
                    }, label: {
                        Text(PitstopAPPStrings.Common.delete)
                            .font(Typography.headerM)
                            .foregroundStyle(appState.currentTheme.accentColor)
                    })
                }
            }

            ToolbarItemGroup(placement: .keyboard) {
                HStack {
                    Spacer()
                    Button(action: {
                        reminderInputFocus = nil

                    }, label: {
                        Image(systemName: "keyboard.chevron.compact.down")
                            .resizable()
                            .foregroundColor(Palette.black)
                    })
                    Spacer()
                }
            }
        }
        .alert(alertTitle,
               isPresented: $showAlert,
               actions: {},
               message: { Text(alertMessage) })
        .alert(isPresented: $showDeleteAlert) {
            Alert(
                title: Text(PitstopAPPStrings.Reminder.delete),
                message: Text(PitstopAPPStrings.Common.undone),
                primaryButton: .destructive(Text(PitstopAPPStrings.Common.delete)) {
                    removeNotification(for: reminder)
                    deleteReminder(reminder)
                    navManager.pop()
                },
                secondaryButton: .cancel()
            )
        }
    }
}

private extension ReminderReportView {
    func showAlert(with title: String, and message: String) {
        showAlert.toggle()
        alertTitle = title
        alertMessage = message
    }

    func createReminderNotification() {
        Task {
            do {
                let status = try await NotificationManager.shared.requestAuthNotifications()

                guard status == .authorized else {
                    showAlert(with: PitstopAPPStrings.Common.attention, and: PitstopAPPStrings.Reminder.enableNotification)
                    return
                }

                await NotificationManager.shared.createNotification(for: ReminderNotificationData(from: reminder))

                try reminder.saveToModelContext(context: modelContext)

                navManager.pop()
            } catch {
                showAlert(with: PitstopAPPStrings.Common.error, and: error.localizedDescription)
            }
        }
    }

    func removeNotification(for reminder: Reminder) {
        let inputData = ReminderNotificationData(from: reminder)
        Task {
            await NotificationManager.shared.removeNotification(for: inputData)
        }
    }

    func deleteReminder(_ reminder: Reminder) {
        modelContext.delete(reminder)
        do {
            try modelContext.save()
        } catch {
            print("Failed to delete reminder: \(error)")
        }
    }
}

enum ReminderInputFocusField: Hashable {
    case reminderTitle
    case note
}
