//
//  UpdatePlanete.swift
//  BonheurApp
//
//  Created by caroletm on 15/10/2025.
//

import Fluent

struct UpdatePlaneteSouvenir2 : AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema("Souvenir")

            .field("planeteSouvenir_Id", .uuid, .required,
                .references("PlaneteSouvenir", "id", onDelete: .cascade))
                   .update()
    }
    func revert(on db: any Database) async throws {
        try await db.schema("PlaneteSouvenir")
            .deleteField("planeteSouvenir_Id")
            .update()
    }
}

struct UpdatePlaneteSouvenir3 : AsyncMigration {
    func prepare(on db : any Database) async throws {
        try await db.schema("PlaneteSouvenir")
        
            .field("planeteId", .uuid, .required,
                    .references("Planete", "id", onDelete: .cascade))
                   .update()
    }
func revert(on db: any Database) async throws {
    try await db.schema("PlaneteSouvenir")
        .deleteField("planeteId")
        .update()
    }
}

struct UpdatePlaneteExplo : AsyncMigration {
    func prepare(on db : any Database) async throws {
        try await db.schema("MapPoint")
        
            .field("planeteExplo_Id", .uuid, .required,
                   .references("PlaneteExplo", "id", onDelete: .cascade))
            .update()
    }
    func revert(on db: any Database) async throws {
        try await db.schema("MapPoint")
            .deleteField("planeteExplo_Id")
            .update()
    }
}

struct UpdatePlaneteExplo2 : AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema("PlaneteExplo")
        
            .field("planeteId", .uuid, .required,
                   .references("Planete","id", onDelete: .cascade))
            .update()
    }
    func revert(on db: any Database) async throws {
        try await db.schema("PlaneteExplo")
            .deleteField("planeteId")
            .update()
    }
}

struct UpdatePlaneteMusic : AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema("Musique")
        
            .field("planeteMusic_Id", .uuid, .required,
                   .references( "PlaneteMusic", "id", onDelete: .cascade))
            .update()
    }
    func revert(on db: any Database) async throws {
        try await db.schema("Musique")
            .deleteField("planeteMusic_Id")
            .update()
    }
}

struct UpdatePlaneteMusic2 : AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema("PlaneteMusic")
        
            .field("planeteId", .uuid, .required,
                   .references("Planete","id", onDelete: .cascade))
            .update()
    }
    func revert(on db: any Database) async throws {
        try await db.schema("PlaneteMusic")
            .deleteField("planeteId")
            .update()
    }
}

struct UpdatePlaneteMission : AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema("Mission")
        
            .field("planeteMission_Id", .uuid, .required,
                   .references( "PlaneteMission", "id", onDelete: .cascade))
            .update()
    }
    func revert(on database: any Database) async throws {
        try await database.schema("Mission")
            .deleteField("planeteMission_Id")
            .update()
    }
}

struct UpdatePlaneteMission2 : AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("PlaneteMission")
        
            .field("planeteId", .uuid, .required,
                   .references("Planete","id", onDelete: .cascade))
            .update()
    }
    func revert(on database: any Database) async throws {
        try await database.schema("PlaneteMission")
            .deleteField("planeteId")
            .update()
    }
}


struct UpdatePlanetePhilo : AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("CourantPhilo")
        
            .field("planetePhilo_Id", .uuid, .required,
                   .references( "PlanetePhilo", "id", onDelete: .cascade))
            .update()
    }
    func revert(on database: any Database) async throws {
        try await database.schema("CourantPhilo")
            .deleteField("planetePhilo_Id")
            .update()
    }
}

struct UpdatePlanetePhilo2 : AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("PlanetePhilo")
        
            .field("planeteId", .uuid, .required,
                   .references("Planete","id", onDelete: .cascade))
            .update()
    }
    func revert(on database: any Database) async throws {
        try await database.schema("PlanetePhilo")
            .deleteField("planeteId")
            .update()
    }
}


