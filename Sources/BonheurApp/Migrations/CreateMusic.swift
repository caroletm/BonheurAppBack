//
//  CreateMusic.swift
//  BonheurApp
//
//  Created by caroletm on 14/10/2025.
//

import Fluent

struct CreateMusic: AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema("Musique")
        .id()
        .field("nom", .string)
        .field("audio", .string)
        .field("logo", .string)
        .create()
        }
    func revert(on db: any Database) async throws {
        try await db.schema("Musique").delete()
    }
}
