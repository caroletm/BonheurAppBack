//
//  MapPointController.swift
//  BonheurApp
//
//  Created by cyrilH on 19/10/2025.
//

import Vapor
import Fluent

struct MapPointController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let maps = routes.grouped("mappoints")
        maps.get(use: getAll)
        maps.get(":mapID", use: getById)
    }
    
    func getAll(req: Request) async throws -> [MapPointDTO] {
        let points = try await MapPoint.query(on: req.db).all()
        return points.map {
            MapPointDTO(
                id: $0.id,
                nom: $0.nom,
                theme: $0.theme,
                latitude: $0.latitude,
                longitude: $0.longitude,
                planeteExploId: $0.$planeteExplo.id
            )
        }
    }
    func getById(req: Request) async throws -> MapPointDTO {
            guard let point = try await MapPoint.find(req.parameters.get("mapID"), on: req.db) else {
                throw Abort(.notFound)
            }
            return MapPointDTO(
                id: point.id,
                nom: point.nom,
                theme: point.theme,
                latitude: point.latitude,
                longitude: point.longitude,
                planeteExploId: point.$planeteExplo.id
            )
        }
    }
