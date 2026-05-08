//
//  Reminder.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 27/12/24.
//

import Foundation
import OSLog
import SwiftData

private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.pitstop", category: "persistence")

@Model
public final class Reminder: Identifiable {
    @Attribute(.unique)
    public var uuid: UUID

    public var title: String
    public var category: ServiceCategory
//    var recurrence: Int16
    public var note: String
    public var date: Date
//    var distance: String?

    public init(
        uuid: UUID = UUID(),
        title: String = "",
        category: ServiceCategory,
//        recurrence: Int16, // TODO: Implement recurrence of reminder
        note: String = "",
        date: Date
//        distance: String? = nil // TODO: Implement reminders on odometer amount
    ) {
        self.uuid = uuid
        self.title = title
        self.category = category
//        self.recurrence = recurrence
        self.note = note
        self.date = date
//        self.distance = distance
    }

    public static func mock() -> Reminder {
        .init(title: "", category: .maintenance, date: Date())
    }

    public func saveToModelContext(context: ModelContext) throws {
        context.insert(self)
        try context.save()
        logger.debug("Reminder saved successfully")
    }

    public enum Typology: String, CaseIterable, Hashable {
        case date = "Date"
    }
}
