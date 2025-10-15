//
//  UpdateMapPoint.swift
//  BonheurApp
//
//  Created by caroletm on 15/10/2025.
//

import Fluent

struct UpdateMapPoint : AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema("MapPoint")
        
        .field("souvenirMap_Id", .uuid, .required,
            .references("SouvenirMap","id", onDelete: .cascade))
        .update()
    }
    func revert(on db: any Database) async throws {
        try await db.schema("MapPoint")
            .deleteField("souvenirMap_Id")
            .update()
    }
}

