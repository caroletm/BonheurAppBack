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
        visites.post(use: create)
    }
    
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
}
