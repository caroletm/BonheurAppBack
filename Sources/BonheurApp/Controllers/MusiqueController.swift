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
    
    // GET /musiques
    @Sendable
    func getAll(req: Request) async throws -> [MusicDTO] {
        let musiques = try await Musique.query(on: req.db).with(\.$planeteMusic).all()
        return musiques.map {
            MusicDTO(
                id: $0.id,
                nom: $0.nom,
                audio: $0.audio,
                logo: $0.logo,
                planeteMusicId: $0.$planeteMusic.id
            )
        }
    }
    
    // GET /musiques/:musiqueID
    @Sendable
    func getById(req: Request) async throws -> MusicDTO {
        guard let musique = try await Musique.find(req.parameters.get("musiqueID"), on: req.db) else {
            throw Abort(.notFound, reason: "Musique introuvable")
        }
        return MusicDTO(
            id: musique.id,
            nom: musique.nom,
            audio: musique.audio,
            logo: musique.logo,
            planeteMusicId: musique.$planeteMusic.id
        )
    }
    
    // POST /musiques
    @Sendable
    func create(req: Request) async throws -> MusicDTO {
        let dto = try req.content.decode(MusicDTO.self)
        
        // Serveur choisit automatiquement la planète musicale
        guard let planeteMusic = try await PlaneteMusic.query(on: req.db).first() else {
            throw Abort(.notFound, reason: "Planete Music introuvable")
        }
        
        let musique = Musique(
            id: UUID(),
            planeteMusicID: planeteMusic.id!,
            nom: dto.nom,
            audio: dto.audio,
            logo: dto.logo
        )
        try await musique.save(on: req.db)
        
        return MusicDTO(
            id: musique.id,
            nom: musique.nom,
            audio: musique.audio,
            logo: musique.logo,
            planeteMusicId: planeteMusic.id
        )
    }
    
    // PUT /musiques/:musiqueID
    @Sendable
    func update(req: Request) async throws -> MusicDTO {
        guard let musique = try await Musique.find(req.parameters.get("musiqueID"), on: req.db) else {
            throw Abort(.notFound, reason: "Musique introuvable")
        }
        let dto = try req.content.decode(MusicDTO.self)
        
        musique.nom = dto.nom
        musique.audio = dto.audio
        musique.logo = dto.logo
        
        try await musique.update(on: req.db)
        
        return MusicDTO(
            id: musique.id,
            nom: musique.nom,
            audio: musique.audio,
            logo: musique.logo,
            planeteMusicId: musique.$planeteMusic.id
        )
    }
    
    // PATCH /musiques/:musiqueID
    @Sendable
    func patch(req: Request) async throws -> MusicDTO {
        guard let musique = try await Musique.find(req.parameters.get("musiqueID"), on: req.db) else {
            throw Abort(.notFound, reason: "Musique introuvable")
        }
        let dto = try req.content.decode(PartialMusicDTO.self)
        
        if let nom = dto.nom { musique.nom = nom }
        if let audio = dto.audio { musique.audio = audio }
        if let logo = dto.logo { musique.logo = logo }
        
        try await musique.update(on: req.db)
        
        return MusicDTO(
            id: musique.id,
            nom: musique.nom,
            audio: musique.audio,
            logo: musique.logo,
            planeteMusicId: musique.$planeteMusic.id
        )
    }
    
    // DELETE /musiques/:musiqueID
    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        guard let musique = try await Musique.find(req.parameters.get("musiqueID"), on: req.db) else {
            throw Abort(.notFound, reason: "Musique introuvable")
        }
        try await musique.delete(on: req.db)
        return .noContent
    }
}

//    Ecrire les fonctions ici :
//    exemple @Sendable func getAllCitations(_ req: Request) async throws -> Response {...}
    
