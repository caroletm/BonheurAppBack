//
//  CourantPhiloController.swift
//  BonheurApp
//
//  Created by caroletm on 19/10/2025.
//

import Fluent
import Vapor

struct CourantPhiloController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let courantsPhilo = routes.grouped("courantsPhilo")
        
        // Ecrire les methodes ici :
        courantsPhilo.get(use: getAllPhilo) // Liste tous les courants philosophiques
        courantsPhilo.post(use: CreatePhilo) // Crée un courant philosophique
        courantsPhilo.get(":id", use: getPhiloById) // Récupère un courant philo par ID
        courantsPhilo.put(":id", use: updatePhiloById) // Met à jour un courant philo par ID
        courantsPhilo.delete(":id", use: deletePhiloById) // Supprime un courant philo par ID
    }
    
    // Ecrire les fonctions ici :
    @Sendable func getAllPhilo(_ req: Request) async throws -> [CourantPhiloDTO] {
        let courantsPhilo = try await CourantPhilo.query(on: req.db).all()
        return courantsPhilo.map {
            CourantPhiloDTO(
                id: $0.id,
                planetePhiloId: $0.$planetePhilo.id,
                nom: $0.nom,
                icon: $0.icon,
                description: $0.description
            )
        }
    }
    
    @Sendable func CreatePhilo(_ req: Request) async throws -> CourantPhiloDTO {
        // Décoder le DTO reçu
        let newPhiloDTO = try req.content.decode(CourantPhiloDTO.self)
        
        // Vérifier que la PlanetePhilo existe
        guard let _ = try await PlanetePhilo.find(newPhiloDTO.planetePhiloId, on: req.db) else {
            throw Abort(.badRequest, reason: "PlanetePhilo with ID \(newPhiloDTO.planetePhiloId) not found")
        }
        
        // Créer une nouvelle instance de CourantPhilo
        let courantPhilo = CourantPhilo()
        courantPhilo.$planetePhilo.id = newPhiloDTO.planetePhiloId
        courantPhilo.nom = newPhiloDTO.nom
        courantPhilo.icon = newPhiloDTO.icon
        courantPhilo.description = newPhiloDTO.description
        
        // Sauvegarder dans la base de données
        try await courantPhilo.save(on: req.db)
        
        // Retourner le DTO avec l'ID généré
        return CourantPhiloDTO(
            id: courantPhilo.id,
            planetePhiloId: courantPhilo.$planetePhilo.id,
            nom: courantPhilo.nom,
            icon: courantPhilo.icon,
            description: courantPhilo.description
        )
    }
    
    @Sendable func getPhiloById(_ req: Request) async throws -> CourantPhiloDTO {
        // Récupérer l'ID depuis les paramètres
        guard let id = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Invalid or missing 'id' parameter")
        }
        
        // Chercher le courant philosophique
        guard let courantPhilo = try await CourantPhilo.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "Courant philosophique not found")
        }
        
        // Retourner le DTO
        return CourantPhiloDTO(
            id: courantPhilo.id,
            planetePhiloId: courantPhilo.$planetePhilo.id,
            nom: courantPhilo.nom,
            icon: courantPhilo.icon,
            description: courantPhilo.description
        )
    }
    
    @Sendable func updatePhiloById(_ req: Request) async throws -> CourantPhiloDTO {
        // Récupérer l'ID depuis les paramètres
        guard let id = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Invalid or missing 'id' parameter")
        }
        
        // Chercher le courant philosophique
        guard let courantPhilo = try await CourantPhilo.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "Courant philosophique not found")
        }
        
        // Décoder les nouvelles données
        let updatedPhiloDTO = try req.content.decode(CourantPhiloDTO.self)
        
        // Vérifier que la PlanetePhilo existe si elle a changé
        if courantPhilo.$planetePhilo.id != updatedPhiloDTO.planetePhiloId {
            guard let _ = try await PlanetePhilo.find(updatedPhiloDTO.planetePhiloId, on: req.db) else {
                throw Abort(.badRequest, reason: "PlanetePhilo with ID \(updatedPhiloDTO.planetePhiloId) not found")
            }
        }
        
        // Mettre à jour les champs
        courantPhilo.$planetePhilo.id = updatedPhiloDTO.planetePhiloId
        courantPhilo.nom = updatedPhiloDTO.nom
        courantPhilo.icon = updatedPhiloDTO.icon
        courantPhilo.description = updatedPhiloDTO.description
        
        // Sauvegarder les modifications
        try await courantPhilo.save(on: req.db)
        
        // Retourner le DTO mis à jour
        return CourantPhiloDTO(
            id: courantPhilo.id,
            planetePhiloId: courantPhilo.$planetePhilo.id,
            nom: courantPhilo.nom,
            icon: courantPhilo.icon,
            description: courantPhilo.description
        )
    }
    
    @Sendable func deletePhiloById(_ req: Request) async throws -> HTTPStatus {
        // Récupérer l'ID depuis les paramètres
        guard let id = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Invalid or missing 'id' parameter")
        }
        
        // Chercher le courant philosophique
        guard let courantPhilo = try await CourantPhilo.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "Courant philosophique not found")
        }
        
        // Supprimer le courant philosophique
        try await courantPhilo.delete(on: req.db)
        
        // Retourner un statut 204 No Content
        return .noContent
    }
}
