//
//  CreateUser.swift
//  BonheurApp
//
//  Created by caroletm on 14/10/2025.
//

import Fluent

struct CreateUser: AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema("users")
            .id()                                   // UUID par défaut, clé primaire
            .field("email", .string, .required)
            .unique(on: "email")
            .create()
    }

    func revert(on db: any Database) async throws {
        try await db.schema("users").delete()
    }
}

