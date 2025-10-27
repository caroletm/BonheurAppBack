//
//  UpdateUser.swift
//  BonheurApp
//
//  Created by caroletm on 15/10/2025.
//

import Fluent
import Vapor

struct UpdateUser: AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema("users")
            .field("nom", .string,.required)
            .field("motDePasse", .string,.required)
            .update()
    }
    func revert(on db: any Database) async throws {
        try await db.schema("users")
            .deleteField("nom")
            .deleteField("motDePasse")
            .update()
    }
}
struct AddRoleToUser : AsyncMigration{
    func prepare(on db: any Database) async throws {
        try await db.schema("users")
            .field("role", .string, .required, .sql(.default("user")))
            .update()
        
            
    }
    func revert(on db: any Database) async throws {
        try await db.schema("users").deleteField("role")
            .deleteField("role")
            .update()
    }
}
