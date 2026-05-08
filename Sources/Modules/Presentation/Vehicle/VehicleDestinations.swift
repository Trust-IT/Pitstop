//
//  VehicleDestinations.swift
//  Pitstop
//
//  Created by Ivan Voloshchuk on 29/04/25.
//

import NavigatorUI
import PitstopData
import SwiftUI

enum VehicleDestinations {
    case reminderList
    case reminderReport(input: Reminder, isEdit: Bool)
    case expiredReminder(input: Reminder)
    case docScanner
}

extension VehicleDestinations: NavigationDestination {
    nonisolated var method: NavigationMethod {
        switch self {
        case .reminderList:
            .managedCover
        default:
            .push
        }
    }

    var body: some View {
        switch self {
        case .reminderList:
            RemindersListView()
        case let .reminderReport(reminder, isEdit):
            ReminderReportView(reminder: reminder, isEditMode: isEdit)
        case let .expiredReminder(reminder):
            ExpiredReminderView(reminder: reminder)
        case .docScanner:
            DocumentScannerView()
        }
    }
}

extension VehicleDestinations: Hashable {
    func hash(into hasher: inout Hasher) {
        switch self {
        case .reminderList:
            hasher.combine(0)
        case let .reminderReport(reminder, isEdit):
            hasher.combine(1)
            hasher.combine(reminder.persistentModelID)
            hasher.combine(isEdit)
        case let .expiredReminder(reminder):
            hasher.combine(2)
            hasher.combine(reminder.persistentModelID)
        case .docScanner:
            hasher.combine(3)
        }
    }
}
