//
//  MusiqueController.swift
//  BonheurApp
//
//  Created by caroletm on 19/10/2025.
//

import Fluent
import Vapor

struct MusiqueController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let musiques = routes.grouped("musiques")
        musiques.get(use: getAll) // GET /musiques
        musiques.get(":musiqueID", use: getById) // GET /musiques/:musiqueID
        musiques.post(use: create) // POST /musiques
        musiques.put(":musiqueID", use: update) // PUT /musiques/:musiqueID
        musiques.patch(":musiqueID", use: patch) // PATCH /musiques/:musiqueID
        musiques.delete(":musiqueID", use: delete) // DELETE /musiques/:musiqueID
       }
    }
    
    //GET /musiques
    func getAll(req: Request) async throws -> [MusicDTO] {
        let musique = try await Musique.query(on: req.db).with(\.$planeteMusic).all()
        return musique.map {
            MusicDTO(id: $0.id, nom: $0.nom, planeteMusiqueId: $0.$planeteMusic.id, audio: $0.audio, logo: $0.logo)
        }
    }
    
    //GET /musiques/:musiqueID
    func getById(req: Request) async throws -> MusicDTO {
            guard let musique = try await Musique.find(req.parameters.get("musiqueID"), on: req.db) else {
                throw Abort(.notFound, reason: "Musique not found")
            }
            return MusicDTO(
                id: musique.id,
                nom: musique.nom,
                planeteMusiqueId: musique.$planeteMusic.id,
                audio: musique.audio,
                logo: musique.logo
            )
        }
    
    //POST /musiques
    func create(req: Request) async throws -> MusicDTO {
            let dto = try req.content.decode(MusicDTO.self)
            guard let planeteId = dto.planeteMusiqueId else {
                throw Abort(.badRequest, reason: "Missing planeteMusqueId")
            }
        let musique = Musique(id: UUID(), planeteMusicID: planeteId, nom: dto.nom,  audio: dto.audio, logo: dto.logo)
        
            try await musique.save(on: req.db)
            return MusicDTO(
                id: musique.id,
                nom: musique.nom,
                planeteMusiqueId: planeteId,
                audio: musique.audio,
                logo: musique.logo
            )
        }
    
    //PUT /musiques/:musiqueID
    func update(req: Request) async throws -> MusicDTO {
        guard let musique = try await  Musique.find(req.parameters.get("musiqueID"), on: req.db) else {
            throw Abort(.notFound, reason: "musique not found")
        }
        let dto = try req.content.decode(MusicDTO.self)
        musique.nom = dto.nom
        if let planeteId = dto.planeteMusiqueId {
            musique.$planeteMusic.id = planeteId
        }
        try await musique.update(on: req.db)
        return MusicDTO(
            id: musique.id,
            nom: musique.nom,
            planeteMusiqueId: musique.$planeteMusic.id,
            audio: musique.audio,
            logo: musique.logo
        )
    }
    
    //PATCH /musiques/:musiqueID
    func patch(req:Request) async throws -> MusicDTO{
        guard let musique = try await Musique.find(req.parameters.get("musiqueID"), on: req.db) else {
            throw Abort(.notFound, reason: "Musique not found")
        }
        let dto = try req.content.decode(PartialMusicDTO.self)
        if let nom = dto.nom {musique.nom = nom}
        if let planeteId = dto.planeteMusicId{musique.$planeteMusic.id = planeteId}
        try await musique.update(on: req.db)
        
        return MusicDTO(
            id: musique.id,
            nom: musique.nom,
            planeteMusiqueId: musique.$planeteMusic.id,
            audio: musique.audio,
            logo: musique.logo
        )
    }
    
    func delete(req: Request) async throws -> HTTPStatus {
        guard let musique = try await Musique.find(req.parameters.get("musiqueID"), on: req.db) else {
            throw Abort (.notFound, reason: "musique not found")
        }
        try await musique.delete(on: req.db)
        return .noContent
    }
    
//    Ecrire les fonctions ici :
//    exemple @Sendable func getAllCitations(_ req: Request) async throws -> Response {...}
    
}
