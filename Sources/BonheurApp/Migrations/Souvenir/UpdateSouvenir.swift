//
//  UpdateSouvenir.swift
//  BonheurApp
//
//  Created by caroletm on 15/10/2025.
//

import Fluent

struct UpdateSouvenirDefi : AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema("SouvenirDefi")
   
        .field("souvenir_id", .uuid, .required,
            .references("Souvenir", "id", onDelete: .cascade))
        .update()
    }
    func revert(on db: any Database) async throws {
        try await db.schema("SouvenirDefi")
            .deleteField("souvenir_id")
            .update()
    }

}

struct UpdateSouvenirMap : AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema("SouvenirMap")

            .field("souvenir_id", .uuid, .required,
                .references("Souvenir", "id", onDelete: .cascade))
                   .update()
    }
    func revert(on db: any Database) async throws {
        try await db.schema("SouvenirMap")
            .deleteField("souvenir_id")
            .update()
    }
}

