//
//  Reminder.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 27/12/24.
//

import Foundation
import OSLog
import SwiftData

@Model
final class Reminder: Identifiable {
    @Attribute(.unique)
    var uuid: UUID

    var title: String
    var category: ServiceCategory
//    var recurrence: Int16
    var note: String
    var date: Date
//    var distance: String?

    init(
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

    static func mock() -> Reminder {
        .init(title: "", category: .maintenance, date: Date())
    }

    func saveToModelContext(context: ModelContext) throws {
        context.insert(self)
        try context.save()
        Logger.persistence.debug("Reminder saved successfully")
    }

    enum Typology: String, CaseIterable, Hashable {
        case date = "Date"
    }
}
