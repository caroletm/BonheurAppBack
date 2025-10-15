//
//  CreateExplo.swift
//  BonheurApp
//
//  Created by caroletm on 14/10/2025.
//


import Fluent

struct CreateMapPoint : AsyncMigration {
    func prepare(on db: any Database) async throws {
        
        let SouvenirTheme = try await db.enum("souvenir_theme").read()
        
        try await db.schema("MapPoint")
            .id()
            .field("nom", .double)
            .field("theme", SouvenirTheme, .required)
            .field("latitude", .double)
            .field("longitude", .double)
            .create()
    }
    func revert(on db: any Database) async throws {
        try await db.schema("MapPoint").delete()
    }
}
