//
//  Document.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 24/12/24.
//

import Foundation
import OSLog
import SwiftData

@Model class Document {
    @Attribute(.unique)
    var uuid: UUID

    @Attribute(.externalStorage)
    var data: Data

    var title: String
    var fileURL: URL?

    init(
        uuid: UUID = UUID(),
        data: Data,
        title: String,
        fileURL: URL? = nil
    ) {
        self.uuid = uuid
        self.data = data
        self.title = title
        self.fileURL = fileURL
    }

    func saveToModelContext(context: ModelContext) throws {
        context.insert(self)
        try context.save()
        Logger.persistence.debug("Document saved successfully")
    }

    static func mock() -> Document {
        Document(uuid: UUID(), data: Data(), title: "DocumentTitle")
    }
}
