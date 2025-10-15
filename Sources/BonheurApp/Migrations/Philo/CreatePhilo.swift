//
//  CreatePhilo.swift
//  BonheurApp
//
//  Created by caroletm on 14/10/2025.
//

import Fluent

struct CreatePhilo: AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema("CourantPhilo")
            .id()
            .field("nom", .string)
            .field("icon", .string)
            .field("description", .string)
            .create()
    }
    func revert(on database: any Database) async throws {
        try await database.schema("CourantPhilo").delete()
    }
}

