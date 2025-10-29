//
//  MapPointController.swift
//  BonheurApp
//
//  Created by caroletm on 19/10/2025.
//

import Fluent
import Vapor

struct MapPointController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let mapPoints = routes.grouped("mapPoints")
        mapPoints.get(use: getAllMapPoints)
        mapPoints.post(use: createMapPoint)
        
        mapPoints.group(":id") { mapPoint in
            mapPoint.get(use: getMapPointById)
            mapPoint.delete(use: deleteMapPointById)
            mapPoint.patch(use: updateMapPointById)
        }
    }
    
    @Sendable
    func getAllMapPoints(_ req: Request) async throws -> [MapPointDTO] {
        let mapPoint = try await MapPoint.query(on: req.db).all()
        return mapPoint.map { MapPointDTO(id : $0.id, nom : $0.nom, photo: $0.photo ?? "photoDog", theme : $0.theme, description: $0.description, latitude : $0.latitude, longitude: $0.longitude ) }
    }
    
    @Sendable
    func getMapPointById(_ req: Request) async throws -> MapPoint {
        guard let mapPoint = try await MapPoint.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        return mapPoint
    }
    
//     POST/MapPoints/
    @Sendable
    func createMapPoint(_ req: Request) async throws -> MapPointDTO {
        let dto = try req.content.decode(MapPointDTO.self)
        
        guard let planeteExplo = try await PlaneteExplo.query(on: req.db).first() else {
            throw Abort(.notFound, reason : "Planete Explo introuvable")
        }
        
        guard let user = try await User.query(on: req.db).first() else {
            throw Abort(.notFound, reason: "Utilisateur introuvable")
        }
        
        guard let planeteSouvenir = try await PlaneteSouvenir.query(on: req.db).first() else {
            throw Abort(.notFound, reason : "Planete Souvenir introuvable")
        }
        
        let mapPoint = MapPoint(
            id : UUID(),
            planeteExploID: planeteExplo.id!,
            nom : dto.nom,
            photo: dto.photo,
            theme : dto.theme,
            description: dto.description,
            latitude : dto.latitude,
            longitude: dto.longitude
        )
        
        try await mapPoint.save(on: req.db)
        
        let souvenirMap = SouvenirMap(
            id: UUID(),
            latitude: dto.latitude,
            longitude: dto.longitude,
            mapPointID: mapPoint.id!)
        
        try await souvenirMap.save(on: req.db)
        
        let souvenir = Souvenir(
            id: UUID(),
            nom: dto.nom,
            photo: dto.photo ?? "photoDog",
            description: dto.description,
            theme: dto.theme,
            type: .mapInsert,
            userId: user.id!,
            planeteSouvenirId: planeteSouvenir.id!,
            souvenirMapId : souvenirMap.id!
        )
        
        try await souvenir.save(on: req.db)
                
        return MapPointDTO(
            id: mapPoint.id,
            nom: mapPoint.nom,
            photo : mapPoint.photo,
            theme: mapPoint.theme,
            description: mapPoint.description,
            latitude: mapPoint.latitude,
            longitude: mapPoint.longitude,
            planeteExploId: planeteExplo.id
        )
    }
    
    //DELETE/MapPoints/:id
    @Sendable
    func deleteMapPointById(_ req: Request) async throws -> Response {
        guard let mapPoint = try await MapPoint.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.badRequest, reason: "Id invalide")
        }
        try await mapPoint.delete(on: req.db)
        return Response(status: .noContent)
    }
    
    //PATCH/MapPoints/:id
    @Sendable
    func updateMapPointById(_ req: Request) async throws -> MapPointDTO {
        
        let dto = try req.content.decode(UpdateMapPointDTO.self)
        
        guard dto.nom != nil ||
                dto.photo != nil ||
                dto.theme != nil ||
                dto.description != nil ||
                dto.latitude != nil ||
                dto.longitude != nil else {
            throw Abort(.badRequest, reason: "Rien à modifier")
        }
        guard let id = req.parameters.get("id", as : UUID.self),
              let mapPoint = try await MapPoint.find(id, on: req.db) else
        {
            throw Abort(.notFound, reason : "id introuvable")
        }
        
        if let n = dto.nom { mapPoint.nom = n }
        if let p = dto.photo { mapPoint.photo = p }
        if let t = dto.theme { mapPoint.theme = t }
        if let d = dto.description { mapPoint.description = d }
        if let la = dto.latitude { mapPoint.latitude = la }
        if let lo = dto.longitude { mapPoint.longitude = lo }

        if try await MapPoint.query(on: req.db)
            .filter(\.$nom == mapPoint.nom)
            .filter(\.$photo == mapPoint.photo)
            .filter(\.$theme == mapPoint.theme)
            .filter(\.$description == mapPoint.description)
            .filter(\.$latitude == mapPoint.latitude)
            .filter(\.$longitude == mapPoint.longitude)
            .first() != nil {
            throw Abort(.badRequest, reason: "Un autre point sur la carte possède ces attributs")
        }
        try await mapPoint.save(on: req.db)
        
        guard let planeteExplo = try await PlaneteExplo.query(on: req.db).first() else {
            throw Abort(.notFound, reason : "Planete Explo introuvable")
        }
        
        return MapPointDTO(
            id: mapPoint.id,
            nom: mapPoint.nom,
            photo : mapPoint.photo,
            theme: mapPoint.theme,
            description: mapPoint.description,
            latitude: mapPoint.latitude,
            longitude: mapPoint.longitude,
            planeteExploId: planeteExplo.id
        )
    }
}
