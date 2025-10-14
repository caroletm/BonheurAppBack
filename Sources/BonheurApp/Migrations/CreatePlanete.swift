//
//  CreatePlanete.swift
//  BonheurApp
//
//  Created by caroletm on 14/10/2025.
//

import Fluent

struct CreatePlanete : AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema("Planete")
            .id()
            .field("nom", .string)
            .field("description", .string)
            .field("image", .string)
            .field("onboardingDescription", .string)
            .field("iconOnboarding", .string)
            .field("backgroundPlanete", .string)
            .field("isVisited", .bool)
            .create()
    }
    func revert(on db: any Database) async throws {
        try await db.schema("Planete").delete()
    }
}

struct CreatePlaneteExplo : AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema("PlaneteExplo")
            .id()
            .create()
    }
    func revert(on db: any Database) async throws {
        try await db.schema("PlaneteExplo").delete()
    }
}

struct CreatePlaneteMusic : AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema("PlaneteMusic")
            .id()
            .create()
    }
    func revert(on db: any Database) async throws {
        try await db.schema("PlaneteMusic").delete()
    }
}

struct CreatePlanetePhilo : AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema("PlanetePhilo")
            .id()
            .create()
    }
    func revert(on db: any Database) async throws {
        try await db.schema("PlanetePhilo").delete()
    }
}

struct CreatePlaneteMission : AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema("PlaneteMission")
            .id()
            .create()
    }
    func revert(on db: any Database) async throws {
        try await db.schema("PlaneteMission").delete()
    }
}

struct CreatePlaneteSouvenir : AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema("PlaneteSouvenir")
            .id()
            .create()
    }
    func revert(on db: any Database) async throws {
        try await db.schema("PlaneteSouvenir").delete()
    }
}

