//
//  UpdateMapPoint.swift
//  BonheurApp
//
//  Created by caroletm on 15/10/2025.
//

import Fluent

//struct UpdateMapPoint : AsyncMigration {
//    func prepare(on db: any Database) async throws {
//        try await db.schema("MapPoint")
//        
//        .field("souvenirMap_Id", .uuid, .required,
//            .references("SouvenirMap","id", onDelete: .cascade))
//        .update()
//    }
//    func revert(on db: any Database) async throws {
//        try await db.schema("MapPoint")
//            .deleteField("souvenirMap_Id")
//            .update()
//    }
//}

struct UpdateMapPoint2 : AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema("MapPoint")
        
            .field("photo", .string)
            .field("description", .string)
            .update()
    }
    func revert(on db: any Database) async throws {
        try await db.schema("MapPoint")
            .deleteField("photo")
            .deleteField("description")
            .update()
    }
}

struct DeleteTableMapPoint: AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema("MapPoint")
            .deleteField("nom")
            .update()
    }
    
    func revert(on db: any Database) async throws {
        try await db.schema("MapPoint")
        .field("nom", .string)
        .update()
    }
}

struct UpdateMapPoint3 : AsyncMigration {
    func prepare(on db : any Database) async throws {
        try await db.schema("MapPoint")
            .field("nom", .string)
            .update()
    }
    func revert(on database: any Database) async throws {
        try await database.schema("MapPoint")
            .deleteField("nom")
            .update()
    }
}

//struct DeleteSouvenirMapIdFromMapPoint: AsyncMigration {
//    func prepare(on db: any Database) async throws {
//        try await db.schema("MapPoint")
//            .deleteField("souvenirMap_Id")
//            .update()
//    }
//
//    func revert(on db: any Database) async throws {
//        try await db.schema("MapPoint")
//            .field("souvenirMap_Id", .uuid)
//            .update()
//    }
//}
