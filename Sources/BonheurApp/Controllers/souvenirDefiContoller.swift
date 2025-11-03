//
//  souvenirDefi}.swift
//  BonheurApp
//
//  Created by cyrilH on 29/10/2025.
//

import Fluent
import Vapor

struct souvenirDefiController: RouteCollection{
    func boot(routes: any RoutesBuilder) throws{
        let souvenirDefi = routes.grouped("souvenirDefi").grouped(JWTMiddleware())
        souvenirDefi.post(use: create)
    }
    //POST /souvenirDefi
    func create(req: Request) async throws -> SouvenirDefiDTO {
        
        let dto = try req.content.decode(SouvenirDefiDTO.self)
        
        guard let payload = req.auth.get(UserPayload.self) else {
            throw Abort(.unauthorized, reason: "Utilisateur non authentifié")
        }
        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound, reason: "Utilisateur introuvable")
        }
        guard let mission = try await Mission.find(dto.planetedMission, on: req.db) else {
            throw Abort(.notFound, reason: "Mission introuvable")
        }
        let souvenirDefi = SouvenirDefi(
            id: UUID(),
            isValidated: true,
            missionID: mission.id!
        )
        
        try await souvenirDefi.save(on: req.db)
        
        guard let planeteSouvenir = try await PlaneteSouvenir.query(on: req.db).first() else {
            throw Abort(.notFound, reason: "Planète Souvenir introuvable")
        }
        let souvenir = Souvenir(
            id: UUID(),
            nom: mission.nom,
            photo: dto.photo ?? "",
            description: dto.description,
            theme: dto.theme,
            type: .mission,
            userId: user.id!,
            planeteSouvenirId: planeteSouvenir.id!,
            souvenirDefiId: souvenirDefi.id!
        )
        try await souvenir.save(on: req.db)
        
        return SouvenirDefiDTO(
            id: souvenirDefi.id,
            nom: souvenir.nom,
            photo: souvenir.photo,
            theme: souvenir.theme,
            description: souvenir.description,
            planetedMission: mission.id
        )  
    }
    
}
