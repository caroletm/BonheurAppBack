//
//  CreateSouvenir.swift
//  BonheurApp
//
//  Created by caroletm on 14/10/2025.
//

import Fluent

struct CreateSouvenir : AsyncMigration {
    func prepare(on db: any Database) async throws {
        
        let SouvenirTheme = try await db.enum("souvenir_theme")
            .case("inspiration")
            .case("social")
            .case("apprentissage")
            .case("energie")
            .create()
        
        let SouvenirType = try await db.enum("souvenir_type")
            .case("mapInsert")
            .case("mission")
            .create()
        
        try await db.schema("Souvenir")
            .id()
            .field("nom", .string)
            .field("photo", .string)
            .field("description", .string)
            .field("date", .date)
            .field("theme", SouvenirTheme, .required)
            .field("type", SouvenirType, .required)
            .create()
    }
    func revert(on db: any Database) async throws {
        try await db.schema("Souvenir").delete()
        try await db.enum("souvenir_theme").delete()
        try await db.enum("souvenir_type").delete()
    }
}

struct CreateSouvenirDefi : AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema("SouvenirDefi")
            .id()
            .field("isValidated", .bool)
            .create()
    }
    func revert(on db: any Database) async throws {
        try await db.schema("SouvenirDefi").delete()
    }
}

struct CreateSouvenirMap : AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema("SouvenirMap")
            .id()
            .field("latitude", .double)
            .field("longitude", .double)
            .create()
    }
    func revert(on db: any Database) async throws {
        try await db.schema("SouvenirMap").delete()
    }
}

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
