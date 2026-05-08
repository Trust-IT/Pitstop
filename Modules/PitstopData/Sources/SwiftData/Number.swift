//
//  Number.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 02/01/25.
//

import Foundation
import OSLog
import SwiftData

private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.pitstop", category: "persistence")

@Model
public final class Number: Identifiable {
    @Attribute(.unique)
    public var uuid: UUID

    public var title: String
    public var telephone: String

    public var vehicle: Vehicle?

    public init(
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

    public func insert(context: ModelContext) {
        context.insert(self)
        save(context: context)
    }

    public func save(context: ModelContext) {
        let phone = telephone
        let name = vehicle?.displayName ?? "unknown"
        do {
            try context.save()
            logger.debug("Number \(phone) for \(name) saved successfully")
        } catch {
            logger.error("Error saving Number \(phone) for \(name): \(error)")
        }
    }

    public func delete(context: ModelContext) {
        context.delete(self)
    }
}
