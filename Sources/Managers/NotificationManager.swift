//
//  NotificationManager.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 03/06/22.
//

@preconcurrency import UserNotifications

actor NotificationManager {
    static let shared = NotificationManager()

    private init() {}

    @MainActor
    func requestAuthNotifications() async {
        let center = UNUserNotificationCenter.current()

        let settings = await center.notificationSettings()
        switch settings.authorizationStatus {
        case .notDetermined:
            do {
                try await center.requestAuthorization(options: [.alert, .badge, .sound])
                print("Notification authorization granted.")
            } catch {
                print("Notification authorization error: \(error.localizedDescription)")
            }
        case .denied:
            // TODO: Implement alert to enable notifications
            print("Notifications are denied.")
        case .authorized, .provisional, .ephemeral:
            print("Notifications are already enabled.")
        @unknown default:
            print("Unknown notification authorization status.")
        }
    }

    func createNotification(for reminder: Reminder) async {
        let isItalian = Locale.current.language.languageCode?.identifier == "it"
        let category = reminder.category.rawValue.lowercased()

        let notificationBody = isItalian
            ? "Hai un nuovo promemoria in \(category)"
            : "\(String(localized: "You have a new "))\(category)\(String(localized: " reminder"))"

        let content = UNMutableNotificationContent()
        content.title = reminder.title
        content.body = notificationBody
        content.sound = .default

        let triggerDateComponents = Calendar.current.dateComponents([
            .day, .month, .year, .hour, .minute
        ], from: reminder.date)

        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: reminder.uuid.uuidString, content: content, trigger: trigger)

        do {
            try await UNUserNotificationCenter.current().add(request)
            print("Notification added successfully for reminder: \(reminder.title)")
        } catch {
            print("Error adding notification request: \(error.localizedDescription)")
        }
    }

    func removeNotification(for reminder: Reminder) async {
        let center = UNUserNotificationCenter.current()

        let requests = await center.pendingNotificationRequests()
        let identifiersToRemove = requests.filter { $0.identifier == reminder.uuid.uuidString }.map(\.identifier)

        center.removePendingNotificationRequests(withIdentifiers: identifiersToRemove)
        print("Notifications unscheduled: \(identifiersToRemove)")
    }
}
