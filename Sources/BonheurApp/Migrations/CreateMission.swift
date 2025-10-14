//
//  CreateMission.swift
//  BonheurApp
//
//  Created by caroletm on 14/10/2025.
//

import Fluent

struct CreateMission : AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema("Mission")
            .id()
            .field("nom",.string)
            .create()
    }
    func revert(on db: any Database) async throws {
        try await db.schema("Mission").delete()
    }
}
