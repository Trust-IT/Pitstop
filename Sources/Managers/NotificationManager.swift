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
    func requestAuthNotifications() async throws -> UNAuthorizationStatus {
        let center = UNUserNotificationCenter.current()
        
        let settings = await center.notificationSettings()
        switch settings.authorizationStatus {
        case .notDetermined:
            do {
                let hasAccepted = try await center.requestAuthorization(options: [.alert, .badge, .sound])
                return hasAccepted ? .authorized : .denied
            } catch {
                throw error
            }
        case .denied:
            return settings.authorizationStatus
        case .authorized, .provisional, .ephemeral:
            return settings.authorizationStatus
        @unknown default:
            throw StatusError.unknownStatus
        }
    }

    func createNotification(for reminder: ReminderNotificationData) async {
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

    func removeNotification(for reminder: ReminderNotificationData) async {
        let center = UNUserNotificationCenter.current()

        let requests = await center.pendingNotificationRequests()
        let identifiersToRemove = requests.filter { $0.identifier == reminder.uuid.uuidString }.map(\.identifier)

        center.removePendingNotificationRequests(withIdentifiers: identifiersToRemove)
        print("Notifications unscheduled: \(identifiersToRemove)")
    }
}

extension NotificationManager {
    enum StatusError: Error {
        case unknownStatus
        
        var localizedDescription: String {
            switch self {
            case .unknownStatus:
                return "Unknown status"
            }
        }
    }
}

struct ReminderNotificationData {
    let uuid: UUID
    let title: String
    let date: Date
    let category: ServiceCategory

    init(from reminder: Reminder) {
        self.init(
            uuid: reminder.uuid,
            title: reminder.title,
            date: reminder.date,
            category: reminder.category
        )
    }

    init(uuid: UUID, title: String, date: Date, category: ServiceCategory) {
        self.uuid = uuid
        self.title = title
        self.date = date
        self.category = category
    }
}
