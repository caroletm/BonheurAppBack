//
//  CitationController.swift
//  BonheurApp
//
//  Created by caroletm on 17/10/2025.
//
//
import Fluent
import Vapor

struct CitationController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let citations = routes.grouped("citations")
        
        // Ecrire les methodes ici :
        citations.get(use: getAllCitations) // Liste toutes les citations
        citations.post(use: CreateCitations) // Crée une citation
        citations.get(":id", use: getCitationsById) // Récupère une citation par ID
        citations.delete(":id", use: deleteCitationsById) // Supprime une citation par ID
        citations.put(":id", use: updateCitationsById) // met a jour les citations par ID
    }
    
    // Ecrire les fonctions ici :
    @Sendable func getAllCitations(_ req: Request) async throws -> [CitationDTO] {
        let citations = try await Citation.query(on: req.db).all()
        return citations.map {
            CitationDTO(id: $0.id, texte: $0.text)
        }
    }
    
    @Sendable func CreateCitations(_ req: Request) async throws -> CitationDTO {
        // Décoder le DTO reçu
        let newCitationDTO = try req.content.decode(CitationDTO.self)
        
        // Créer une nouvelle instance de Citation
        let citation = Citation(id:newCitationDTO.id, text: newCitationDTO.texte)
        citation.text = newCitationDTO.texte
        
        // Sauvegarder dans la base de données
        try await citation.save(on: req.db)
        
        // Retourner le DTO avec l'ID généré
        return CitationDTO(id: citation.id, texte: citation.text)
    }
    
    @Sendable func getCitationsById(_ req: Request) async throws -> CitationDTO {
        // Récupérer l'ID depuis les paramètres
        guard let id = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Invalid or missing 'id' parameter")
        }
        
        // Chercher la citation
        guard let citation = try await Citation.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "Citation not found")
        }
        
        // Retourner le DTO
        return CitationDTO(id: citation.id, texte: citation.text)
    }
    
    @Sendable func deleteCitationsById(_ req: Request) async throws -> HTTPStatus {
        // Récupérer l'ID depuis les paramètres
        guard let id = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Invalid or missing 'id' parameter")
        }
        
        // Chercher la citation
        guard let citation = try await Citation.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "Citation not found")
        }
        
        // Supprimer la citation
        try await citation.delete(on: req.db)
        
        // Retourner un statut 204 No Content
        return .noContent
    
    }
    @Sendable func updateCitationsById(_ req: Request) async throws -> CitationDTO {
            // Récupérer l'ID depuis les paramètres
            guard let id = req.parameters.get("id", as: UUID.self) else {
                throw Abort(.badRequest, reason: "Invalid or missing 'id' parameter")
            }
            
            // Chercher la citation
            guard let citation = try await Citation.find(id, on: req.db) else {
                throw Abort(.notFound, reason: "Citation not found")
            }
            
            // Décoder les nouvelles données
            let updatedCitationDTO = try req.content.decode(CitationDTO.self)
            
            // Mettre à jour les champs
            citation.text = updatedCitationDTO.texte
            
            // Sauvegarder les modifications
            try await citation.save(on: req.db)
            
            // Retourner le DTO mis à jour
            return CitationDTO(id: citation.id, texte: citation.text)
        }
}
