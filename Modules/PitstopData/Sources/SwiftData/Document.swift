//
//  Document.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 24/12/24.
//

import Foundation
import OSLog
import SwiftData

private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.pitstop", category: "persistence")

@Model
public class Document {
    @Attribute(.unique)
    public var uuid: UUID

    @Attribute(.externalStorage)
    public var data: Foundation.Data

    public var title: String
    public var fileURL: URL?

    public init(
        uuid: UUID = UUID(),
        data: Foundation.Data,
        title: String,
        fileURL: URL? = nil
    ) {
        self.uuid = uuid
        self.data = data
        self.title = title
        self.fileURL = fileURL
    }

    public func saveToModelContext(context: ModelContext) throws {
        context.insert(self)
        try context.save()
        logger.debug("Document saved successfully")
    }

    public static func mock() -> Document {
        Document(uuid: UUID(), data: Foundation.Data(), title: "DocumentTitle")
    }
}
