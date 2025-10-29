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
        
            .field("souvenirDefi_Id", .uuid,
                   .references("SouvenirDefi","id", onDelete: .cascade))
            .update()
    }
    func revert(on db: any Database) async throws {
        try await db.schema("Mission")
            .deleteField("souvenirDefi_Id")
            .update()
    }
}

struct DeleteSouvenirMapIdFromMission: AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema("Mission")
            .deleteField("souvenirDefi_Id")
            .update()
    }

    func revert(on db: any Database) async throws {
        try await db.schema("Mission")
            .field("souvenirDefi_Id", .uuid)
            .update()
    }
}

//struct UpdatemissionIdNotRequired : AsyncMigration {
//    func prepare(on database: any Database) async throws {
//
//    }
//}
