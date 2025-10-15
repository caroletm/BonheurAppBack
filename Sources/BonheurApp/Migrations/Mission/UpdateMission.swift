//
//  UpdateMission.swift
//  BonheurApp
//
//  Created by caroletm on 15/10/2025.
//

import Fluent

struct UpdateMission : AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema("Mission")
        
            .field("souvenirDefi_Id", .uuid, .required,
                   .references("SouvenirDefi","id", onDelete: .cascade))
            .update()
    }
    func revert(on db: any Database) async throws {
        try await db.schema("Mission")
            .deleteField("souvenirDefi_Id")
            .update()
    }
}
