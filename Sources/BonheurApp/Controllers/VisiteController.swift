//
//  VisiteController.swift
//  BonheurApp
//
//  Created by cyrilH on 19/10/2025.
//
import Vapor
import Fluent

struct VisiteController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let visites = routes.grouped("visites")
        visites.get(use: getAll)
        visites.get("user", ":userID", use: getByUser)
        visites.get("planete", ":planeteID", use: getByPlanete)
        visites.get("stats", use: getStats)
        visites.post(use: create)
        visites.delete(":visiteID", use: delete)
    }
    //GET /vivites
    func getAll(req: Request) async throws -> [VisiteDTO] {
        let visites = try await Visite.query(on: req.db)
            .with(\.$user)
            .with(\.$planete)
            .all()
        
        return visites.map { visite in
            VisiteDTO(
                id: visite.id,
                dateTime: visite.dateTime,
                userId: visite.$user.id,
                planeteId: visite.$planete.id
            )
        }
    }
    //GET /vivites/:userID
    func getByUser(req: Request) async throws -> [VisiteDTO] {
        guard let userID = req.parameters.get("userID", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Invalid user ID")
        }
        
        let visites = try await Visite.query(on: req.db)
            .filter(\.$user.$id == userID)
            .with(\.$planete)
            .all()
        
        return visites.map { visite in
            VisiteDTO(
                id: visite.id,
                dateTime: visite.dateTime,
                userId: visite.$user.id,
                planeteId: visite.$planete.id
            )
        }
    }
    //GET/visites/planete/:planeteId
    func getByPlanete(req: Request) async throws -> [VisiteDTO]{
        guard let planeteID = req.parameters.get("planeteID", as: UUID.self) else {
            throw Abort(.badRequest,reason: "invalid planegte ID")
        }
        let visites = try await Visite.query(on: req.db)
            .filter(\.$planete.$id == planeteID)
            .with(\.$user)
            .all()
        return visites.map {
            VisiteDTO(
                id: $0.id,
                dateTime: $0.dateTime,
                userId: $0.$user.id,
                planeteId: $0.$planete.id
            )
        }
    }
    //POST /visites
    func create(req: Request) async throws -> VisiteDTO {
        let dto = try req.content.decode(VisiteDTO.self)
        
        guard try await User.find(dto.userId, on: req.db) != nil else {
            throw Abort(.notFound, reason: "User not found")
        }
        
        guard try await Planete.find(dto.planeteId, on: req.db) != nil else {
            throw Abort(.notFound, reason: "Planete not found")
        }
        
        let existingVisite = try await Visite.query(on: req.db)
            .filter(\.$user.$id == dto.userId)
            .filter(\.$planete.$id == dto.planeteId)
            .first()
        
        if let existing = existingVisite {
            return VisiteDTO(
                id: existing.id,
                dateTime: existing.dateTime,
                userId: existing.$user.id,
                planeteId: existing.$planete.id
            )
        }
        
        let visite = Visite(
            id: UUID(),
            dateTime: Date(),
            userID: dto.userId,
            planeteID: dto.planeteId
        )
        
        try await visite.save(on: req.db)
        
        return VisiteDTO(
            id: visite.id,
            dateTime: visite.dateTime,
            userId: visite.$user.id,
            planeteId: visite.$planete.id
        )
    }
    //DELETE /visites/:visiteID
    func delete(req: Request) async throws -> HTTPStatus {
        guard let visite = try await Visite.find(req.parameters.get("visiteID"), on: req.db) else{
            throw Abort(.notFound)
        }
        try await visite.delete(on: req.db)
        return .noContent
    }
    //GET /visites/stats
    func getStats(req: Request) async throws -> VisiteStatsDTO {
        let total = try await Visite.query(on: req.db).count()
        let uniqueUsers = try await Visite.query(on: req.db)
            .unique()
            .all(\.$user.$id)
        let uniquePlanetes = try await Visite.query(on: req.db)
            .unique()
            .all(\.$planete.$id)
        let visites = try await Visite.query(on: req.db)
            .with(\.$planete)
            .all()
        
        var planeteCount: [UUID: Int] = [:]
        for visite in visites {
            let planeteId = visite.$planete.id
            planeteCount[planeteId, default: 0] += 1
        }
        
        let mostVisited = planeteCount.max(by: { $0.value < $1.value })
        
        var mostVisitedPlaneteName = "Aucune visite enregistrée"
        if let (planeteId, _) = mostVisited,
           let planete = try await Planete.find(planeteId, on: req.db) {
            mostVisitedPlaneteName = planete.nom
        }
        
        return VisiteStatsDTO(
            totalVisites: total,
            utilisateursActifs: uniqueUsers.count,
            planetesVisitees: uniquePlanetes.count,
            planeteLaPlusVisitee: mostVisitedPlaneteName
        )
    }

    
    
    
}
