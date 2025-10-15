//
//  CreateVisite.swift
//  BonheurApp
//
//  Created by caroletm on 15/10/2025.
//

import Fluent

struct CreateVisite: AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema("Visite")
            .id()
            .field("dateTime", .datetime)
            .create()
    }
    func revert(on db: any Database) async throws {
        try await db.schema("Visite").delete()
    }
}
