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

struct UpdateSouvenirMap2 : AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("SouvenirMap")
            .field("mapPoint_Id", .uuid, .required,
                    .references("MapPoint", "id", onDelete: .cascade))
            .update()
    }
    func revert(on db: any Database) async throws {
        try await db.schema("SouvenirMap")
            .deleteField("mapPoint_Id")
            .update()
    }
}

struct UpdateSouvenirMap3 : AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("SouvenirMap")
            .deleteField( "souvenir_id")
            .update()
    }
    func revert(on database: any Database) async throws {
        try await database.schema("SouvenirMap")
        .field("souvenir_id", .uuid)
        .update()
    }
}

struct UpdateSouvenirMap4 : AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("Souvenir")
            .field("souvenirMap_Id", .uuid, .required,
                   .references( "SouvenirMap", "id", onDelete: .cascade))
            .update()
    }
    func revert(on db: any Database) async throws {
        try await db.schema("Souvenir")
            .deleteField("souvenirMap_Id")
            .update()
    }
}

struct UpdateSouvenirFromUser : AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("Souvenir")
            .field("user_Id", .uuid, .required,
                   .references( "users", "id", onDelete: .cascade))
            .update()
    }
    func revert(on db: any Database) async throws {
        try await db.schema("Souvenir")
            .deleteField("user_Id")
            .update()
    }
}

