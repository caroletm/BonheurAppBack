//
//  CreateCitation.swift
//  BonheurApp
//
//  Created by caroletm on 14/10/2025.
//

import Fluent

struct CreateCitation : AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema("Citation")
            .id()
            .field("text", .string)
            .create()
    }
    func revert(on db: any Database) async throws {
        try await db.schema("Citation").delete()
    }
}
