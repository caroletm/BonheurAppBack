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
    }
}
