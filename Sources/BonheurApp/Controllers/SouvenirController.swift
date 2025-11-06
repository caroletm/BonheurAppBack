//
//  SouvenirController.swift
//  BonheurApp
//
//  Created by caroletm on 19/10/2025.
//

import Fluent
import Vapor

struct SouvenirController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let souvenirs = routes.grouped("souvenirs")
        souvenirs.get(use: getAllSouvenirs)
        
        souvenirs.group(":id") { souvenir in
            souvenir.get(use: getSouvenirById)
            souvenir.delete(use: deleteSouvenirById)
            souvenir.patch(use: updateSouvenirById)
        }
        
        // GET/souvenirs
        @Sendable
        func getAllSouvenirs(_ req: Request) async throws -> [SouvenirDTO] {
            
            let souvenirs = try await Souvenir.query(on: req.db).all()
            return souvenirs.map { SouvenirDTO(id: $0.id, nom: $0.nom, photo: $0.photo, description: $0.description, theme: $0.theme, type: $0.type, date: $0.date) }
        }
        
        // GET/souvenirs/id:
        @Sendable
        func getSouvenirById(_ req: Request) async throws -> Souvenir {
            guard let souvenir = try await Souvenir.find(req.parameters.get("id"), on: req.db) else {
                throw Abort(.notFound)
            }
            return souvenir
        }
        
        //DELETE/souvenirs/id:
        @Sendable
        func deleteSouvenirById(_ req: Request) async throws -> Response {
            guard let id = req.parameters.get("id", as: UUID.self),
                  let souvenir = try await Souvenir.find(id, on: req.db) else {
                throw Abort(.notFound, reason: "Souvenir introuvable")
            }
            try await souvenir.delete(on: req.db)
            return Response(status: .noContent)
        }
        
        //PATCH/souvenirs/id:
        @Sendable
        func updateSouvenirById(_ req: Request) async throws -> SouvenirDTO {
            
            let dto = try req.content.decode(UpdateSouvenirDTO.self)
            
            guard dto.nom != nil ||
                    dto.photo != nil ||
                    dto.description != nil ||
                    dto.theme != nil ||
                    dto.type != nil else {
                throw Abort(.badRequest, reason: "Rien à modifier")
            }
            
            guard let id = req.parameters.get("id", as : UUID.self),
                  let souvenir = try await Souvenir.find(id, on: req.db) else
            
            {
                throw Abort(.notFound, reason : "id introuvable")
            }
            
            if let n = dto.nom { souvenir.nom = n }
            if let p = dto.photo { souvenir.photo = p }
            if let d = dto.description { souvenir.description = d }
            if let t = dto.theme { souvenir.theme = t }
            if let ty = dto.type { souvenir.type = ty }
            
            if try await Souvenir.query(on: req.db)
                .filter(\.$nom == souvenir.nom)
                .filter(\.$photo == souvenir.photo)
                .filter(\.$description == souvenir.description)
                .filter(\.$theme == souvenir.theme)
                .filter(\.$type == souvenir.type)
                .first() != nil {
                throw Abort(.badRequest, reason: "Un souvenir existe deja")
            }
            try await souvenir.save(on: req.db)
            
            return SouvenirDTO(
                id: souvenir.id,
                nom: souvenir.nom,
                photo : souvenir.photo,
                description: souvenir.description,
                theme: souvenir.theme,
                type: souvenir.type
            )
        }
    }
}
