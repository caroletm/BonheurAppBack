//
//  SouvenirController.swift
//  BonheurApp
//
//  Created by cyrilH on 19/10/2025.
//


import Vapor
import Fluent

struct SouvenirController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let souvenirs = routes.grouped("souvenirs")
        souvenirs.get(use: getAll)
        souvenirs.get(":souvenirID", use: getById)
        souvenirs.get("user", ":userID", use: getSouvenirsByUser)
        souvenirs.post("from-mission", use: createFromMission)
        souvenirs.post("from-mappoint", use: createFromMapPoint)
        souvenirs.delete(":souvenirID", use: delete)
    }
    
    func getAll(req: Request) async throws -> [SouvenirDTO] {
        let souvenirs = try await Souvenir.query(on: req.db)
            .with(\.$planeteSouvenir)
            .with(\.$user)
            .all()
        
        return souvenirs.map { souvenir in
            SouvenirDTO(
                id: souvenir.id,
                nom: souvenir.nom,
                photo: souvenir.photo,
                description: souvenir.description,
                theme: souvenir.theme,
                type: souvenir.type,
                date: souvenir.date,
                userId: souvenir.$user.id,
                planeteSouvenirId: souvenir.$planeteSouvenir.id
            )
        }
    }
    
    func getById(req: Request) async throws -> SouvenirDTO {
        guard let souvenir = try await Souvenir.find(req.parameters.get("souvenirID"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        return SouvenirDTO(
            id: souvenir.id,
            nom: souvenir.nom,
            photo: souvenir.photo,
            description: souvenir.description,
            theme: souvenir.theme,
            type: souvenir.type,
            date: souvenir.date,
            userId: souvenir.$user.id,
            planeteSouvenirId: souvenir.$planeteSouvenir.id
        )
    }
    
    func getSouvenirsByUser(req: Request) async throws -> [SouvenirDTO] {
        guard let userID = req.parameters.get("userID", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Invalid user ID")
        }
        
        let souvenirs = try await Souvenir.query(on: req.db)
            .filter(\.$user.$id == userID)
            .with(\.$planeteSouvenir)
            .all()
        
        return souvenirs.map { souvenir in
            SouvenirDTO(
                id: souvenir.id,
                nom: souvenir.nom,
                photo: souvenir.photo,
                description: souvenir.description,
                theme: souvenir.theme,
                type: souvenir.type,
                date: souvenir.date,
                userId: souvenir.$user.id,
                planeteSouvenirId: souvenir.$planeteSouvenir.id
            )
        }
    }
    
    
    
    func delete(req: Request) async throws -> HTTPStatus {
        guard let souvenir = try await Souvenir.find(req.parameters.get("souvenirID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await souvenir.delete(on: req.db)
        return .noContent
    }
    
    func createFromMission(req: Request) async throws -> SouvenirDTO {
        let dto = try req.content.decode(CreateSouvenirFromMissionDTO.self)
        
        guard let user = try await User.find(dto.userId, on: req.db) else {
            throw Abort(.notFound, reason: "User not found")
        }
        
        guard let mission = try await Mission.find(dto.missionId, on: req.db) else {
            throw Abort(.notFound, reason: "Mission not found")
        }
        
        try await mission.$planeteMission.load(on: req.db)
        let planeteMission = mission.planeteMission
        try await planeteMission.$planete.load(on: req.db)
        let planete = planeteMission.planete
        
        let visiteExists = try await Visite.query(on: req.db)
            .filter(\.$user.$id == user.id!)
            .filter(\.$planete.$id == planete.id!)
            .first() != nil
        
        guard visiteExists else {
            throw Abort(.badRequest, reason: "User has not visited this planet")
        }
        
        guard let planeteSouvenir = try await PlaneteSouvenir.query(on: req.db)
            .filter(\.$planete.$id == planete.id!)
            .first() else {
            throw Abort(.notFound, reason: "PlaneteSouvenir not found for this planet")
        }
        
        let souvenir = Souvenir(
            nom: dto.nom,
            photo: dto.photo,
            description: dto.description,
            theme: dto.theme,
            type: .mission,
            userId: user.id!,
            planeteSouvenirId: planeteSouvenir.id!
        )
        
        try await souvenir.save(on: req.db)
        
        let souvenirDefi = SouvenirDefi(
            isValidated: true,
            souvenirID: souvenir.id!,
            missionID: mission.id!
        )
        try await souvenirDefi.save(on: req.db)
        
        return SouvenirDTO(
            id: souvenir.id,
            nom: souvenir.nom,
            photo: souvenir.photo,
            description: souvenir.description,
            theme: souvenir.theme,
            type: souvenir.type,
            date: souvenir.date,
            userId: souvenir.$user.id,
            planeteSouvenirId: souvenir.$planeteSouvenir.id
        )
    }
    
    func createFromMapPoint(req: Request) async throws -> SouvenirDTO {
        let dto = try req.content.decode(CreateSouvenirFromMapPointDTO.self)
        
        guard let user = try await User.find(dto.userId, on: req.db) else {
            throw Abort(.notFound, reason: "User not found")
        }
        
        guard let mapPoint = try await MapPoint.find(dto.mapPointId, on: req.db) else {
            throw Abort(.notFound, reason: "MapPoint not found")
        }
        
        try await mapPoint.$planeteExplo.load(on: req.db)
        let planeteExplo = mapPoint.planeteExplo
        try await planeteExplo.$planete.load(on: req.db)
        let planete = planeteExplo.planete
        
        let visiteExists = try await Visite.query(on: req.db)
            .filter(\.$user.$id == user.id!)
            .filter(\.$planete.$id == planete.id!)
            .first() != nil
        
        guard visiteExists else {
            throw Abort(.badRequest, reason: "User has not visited this planet")
        }
        
        guard let planeteSouvenir = try await PlaneteSouvenir.query(on: req.db)
            .filter(\.$planete.$id == planete.id!)
            .first() else {
            throw Abort(.notFound, reason: "PlaneteSouvenir not found for this planet")
        }
        
        let souvenir = Souvenir(
            nom: dto.nom,
            photo: dto.photo,
            description: dto.description,
            theme: mapPoint.theme,
            type: .mapInsert,
            userId: user.id!,
            planeteSouvenirId: planete.id!
        )
        
        try await souvenir.save(on: req.db)
        
        let souvenirMap = SouvenirMap(
            latitude: mapPoint.latitude,
            longitude: mapPoint.longitude,
            souvenirID: souvenir.id!,
            mapPointID: mapPoint.id!
        )
        try await souvenirMap.save(on: req.db)
        
        return SouvenirDTO(
            id: souvenir.id,
            nom: souvenir.nom,
            photo: souvenir.photo,
            description: souvenir.description,
            theme: souvenir.theme,
            type: souvenir.type,
            date: souvenir.date,
            userId: souvenir.$user.id,
            planeteSouvenirId: souvenir.$planeteSouvenir.id
        )
    }
}
