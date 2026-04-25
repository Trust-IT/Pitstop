//
//  Number.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 02/01/25.
//

import Foundation
import OSLog
import SwiftData

@Model
final class Number: Identifiable {
    @Attribute(.unique)
    var uuid: UUID

    var title: String
    var telephone: String

    var vehicle: Vehicle?

    init(
        uuid: UUID = UUID(),
        title: String,
        telephone: String,
        vehicle: Vehicle? = nil
    ) {
        self.uuid = uuid
        self.title = title
        self.telephone = telephone
        self.vehicle = vehicle
    }

    // MARK: CRUD

    func insert(context: ModelContext) {
        context.insert(self)
        save(context: context)
    }

    func save(context: ModelContext) {
        let phone = telephone
        let name = vehicle?.displayName ?? "unknown"
        do {
            try context.save()
            Logger.persistence.debug("Number \(phone) for \(name) saved successfully")
        } catch {
            Logger.persistence.error("Error saving Number \(phone) for \(name): \(error)")
        }
    }

    func delete(context: ModelContext) {
        context.delete(self)
    }
}
