//
//  MissionController.swift
//  BonheurApp
//
//  Created by cyrilH on 19/10/2025.
//

import Vapor
import Fluent

struct MissionController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
            let missions = routes.grouped("missions")
            missions.get(use: getAll)
            missions.get(":missionID", use: getById)
            missions.post(use: create)
//            missions.put(":missionID", use: update)
            missions.patch(":missionID", use: patch)
            missions.delete(":missionID", use: delete)
        }
    //GET /missions
    func getAll(req: Request) async throws -> [MissionDTO] {
        let missions = try await Mission.query(on: req.db).with(\.$planeteMission).all()
        return missions.map {
            MissionDTO(id: $0.id, nom: $0.nom, planeteMissionId: $0.$planeteMission.id)
        }
    }
    //GET /missions/:missionID
    func getById(req: Request) async throws -> MissionDTO {
            guard let mission = try await Mission.find(req.parameters.get("missionID"), on: req.db) else {
                throw Abort(.notFound, reason: "Mission not found")
            }
            return MissionDTO(
                id: mission.id,
                nom: mission.nom,
                planeteMissionId: mission.$planeteMission.id
            )
        }
    //POST /missions
    func create(req: Request) async throws -> MissionDTO {
            let dto = try req.content.decode(MissionDTO.self)
            guard let planeteId = dto.planeteMissionId else {
                throw Abort(.badRequest, reason: "Missing planeteMissionId")
            }
            let mission = Mission(nom: dto.nom, planeteMissionID: planeteId)
            try await mission.save(on: req.db)
            return MissionDTO(
                id: mission.id,
                nom: mission.nom,
                planeteMissionId: planeteId
            )
        }
//    //PUT /missions/:missionID
//    func update(req: Request) async throws -> MissionDTO {
//        guard let mission = try await  Mission.find(req.parameters.get("missionID"), on: req.db) else {
//            throw Abort(.notFound, reason: "mission not found")
//        }
//        let dto = try req.content.decode(MissionDTO.self)
//        mission.nom = dto.nom
//        if let planeteId = dto.planeteMissionId {
//            mission.$planeteMission.id = planeteId
//        }
//        try await mission.update(on: req.db)
//        return MissionDTO(
//            id: mission.id,
//            nom: mission.nom,
//            planeteMissionId: mission.$planeteMission.id
//        )
//    }
    
    //PATCH /missions/:missionID
    func patch(req:Request) async throws -> MissionDTO{
        guard let mission = try await Mission.find(req.parameters.get("missionID"), on: req.db) else {
            throw Abort(.notFound, reason: "Mission not found")
        }
        let dto = try req.content.decode(PartialMissionDTO.self)
        if let nom = dto.nom {mission.nom = nom}
//        if let planeteId = dto.planeteMissionId{mission.$planeteMission.id = planeteId}
        try await mission.update(on: req.db)
        
        return MissionDTO(
            id: mission.id,
            nom: mission.nom,
            planeteMissionId: mission.$planeteMission.id
        )
    }
    
    //DELETE /missions/:missionID
    func delete(req: Request) async throws -> HTTPStatus {
        guard let mission = try await Mission.find(req.parameters.get("missionID"), on: req.db) else {
            throw Abort (.notFound, reason: "mission not found")
        }
        try await mission.delete(on: req.db)
        return .noContent
    }
}
