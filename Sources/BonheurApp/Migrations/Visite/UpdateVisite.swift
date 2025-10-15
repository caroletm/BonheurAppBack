//
//  UpdateVisite.swift
//  BonheurApp
//
//  Created by caroletm on 15/10/2025.
//

import Fluent

struct UpdateVisite: AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema("visite")
            .field("user_id", .uuid, .required,
                .references("users", "id", onDelete: .cascade))
            .field("planete_id", .uuid, .required,
                .references("Planete", "id", onDelete: .cascade))
            .update()
    }
    func revert(on db: any Database) async throws {
        try await db.schema("visite")
            .deleteField("user_id")
            .deleteField("planete_id")
            .update()
    }
}
