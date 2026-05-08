//
//  ReminderReportView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 06/05/22.
//

import ChassisUI
import NavigatorUI
import PitstopData
import SwiftUI

struct ReminderReportView: View {
    @Environment(\.navigator) var navigator
    @Environment(AppState.self) var appState: AppState
    @Environment(VehicleManager.self) private var vehicleManager: VehicleManager

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

            Button(PitstopStrings.Localizable.Common.save) {
                createReminderNotification()
            }
            .buttonStyle(Primary())
            .disabled(reminder.title.isEmpty)
        }
        .background(Palette.greyBackground)
        .navigationTitle(PitstopStrings.Localizable.Reminder.new)
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: {
                    navigator.dismiss()
                }, label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Palette.black)
                })
            }

            if isEditMode {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        showDeleteAlert.toggle()
                    }, label: {
                        Text(PitstopStrings.Localizable.Common.delete)
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
                title: Text(PitstopStrings.Localizable.Reminder.delete),
                message: Text(PitstopStrings.Localizable.Common.undone),
                primaryButton: .destructive(Text(PitstopStrings.Localizable.Common.delete)) {
                    removeNotification(for: reminder)
                    vehicleManager.deleteReminder(reminder)
                    navigator.dismiss()
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
                    showAlert(with: PitstopStrings.Localizable.Common.attention, and: PitstopStrings.Localizable.Reminder.enableNotification)
                    return
                }

                await NotificationManager.shared.createNotification(for: ReminderNotificationData(from: reminder))
                vehicleManager.saveReminder(reminder)
                navigator.back()
            } catch {
                showAlert(with: PitstopStrings.Localizable.Common.error, and: error.localizedDescription)
            }
        }
    }

    func removeNotification(for reminder: Reminder) {
        let inputData = ReminderNotificationData(from: reminder)
        Task {
            await NotificationManager.shared.removeNotification(for: inputData)
        }
    }
}

enum ReminderInputFocusField: Hashable {
    case reminderTitle
    case note
}
