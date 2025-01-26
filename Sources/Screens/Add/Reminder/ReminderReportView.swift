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

    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""

    @State private var reminder: Reminder = .mock()

    @FocusState var reminderInputFocus: ReminderInputFocusField?

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
        }
        .background(Palette.greyBackground)
        .navigationTitle("New reminder")
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

            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    createReminderNotification()
                }, label: {
                    Text(String(localized: "Save"))
                        .font(Typography.headerM)
                        .foregroundStyle(appState.currentTheme.accentColor)
                })
                .disabled(reminder.title.isEmpty)
                .opacity(reminder.title.isEmpty ? 0.5 : 1)
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
                    showAlert(with: "Attention", and: "Enable the notifications in the settings before creating a reminder")
                    return
                }

                await NotificationManager.shared.createNotification(for: ReminderNotificationData(from: reminder))

                try reminder.saveToModelContext(context: modelContext)

                navManager.pop()
            } catch {
                showAlert(with: "Error", and: error.localizedDescription)
            }
        }
    }
}

enum ReminderInputFocusField: Hashable {
    case reminderTitle
    case note
}
