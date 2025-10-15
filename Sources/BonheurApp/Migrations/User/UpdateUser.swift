//
//  UpdateUser.swift
//  BonheurApp
//
//  Created by caroletm on 15/10/2025.
//

import Fluent

struct UpdateUser: AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema("users")
            .field("nom", .string,.required)
            .field("motDePasse", .string,.required)
            .update()
    }
    func revert(on db: any Database) async throws {
        try await db.schema("users")
    }
}
