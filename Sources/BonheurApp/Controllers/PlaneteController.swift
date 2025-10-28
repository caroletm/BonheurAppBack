//
//  PlaneteController.swift
//  BonheurApp
//
//  Created by caroletm on 19/10/2025.
//

import Fluent
import Vapor

struct PlaneteController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let planetes = routes.grouped("planetes")
        planetes.get(use: getAllPlanetes)
        planetes.post("explo", use: createPlaneteExplo)
        planetes.post("music", use: createPlaneteMusic)
        planetes.post("philo", use: createPlanetePhilo)
        planetes.post("mission", use: createPlaneteMission)
        planetes.post("souvenir", use: createPlaneteSouvenir)
        
        planetes.group(":id") { planete in
            planete.get(use: getPlaneteById)
            planete.delete(use: deletePlaneteById)
            planete.patch(use: updatePlaneteById)
        }
    }

    // GET/Planetes
    @Sendable
    func getAllPlanetes(_ req: Request) async throws -> [PlaneteDTO] {
        let planetes = try await Planete.query(on: req.db).all()
        return planetes.map { PlaneteDTO(id : $0.id, nom : $0.nom, description : $0.description, image : $0.image, onboardingDescription: $0.onboardingDescription, iconOnboarding : $0.iconOnboarding, backgroundPlanete : $0.backgroundPlanete) }
    }
    
    // GET/Planetes/:id
    @Sendable
    func getPlaneteById(_ req: Request) async throws -> Planete {
        guard let planete = try await Planete.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        return planete
    }
    
    // POST/Planetes/explo
    @Sendable
    func createPlaneteExplo(_ req: Request) async throws -> PlaneteDTO {
        let dto = try req.content.decode(PlaneteDTO.self)
        
        if try await Planete.query(on: req.db)
            .filter(\.$nom == dto.nom)
            .first() != nil {
            throw Abort(.badRequest, reason: "Un planete avec ce nom existe déjà")
        }
        
        let planeteParent = Planete(
            id : UUID(),
            nom : dto.nom,
            description: dto.description,
            image: dto.image,
            onboardingDescription: dto.onboardingDescription,
            iconOnboarding : dto.iconOnboarding,
            backgroundPlanete : dto.backgroundPlanete,
            isVisited: false
        )
        
        try await planeteParent.save(on: req.db)
        
        let planeteExplo = PlaneteExplo(
            id: UUID(),
            planeteID: planeteParent.id!
        )
        
        try await planeteExplo.save(on: req.db)
        
        return PlaneteDTO(
            id: planeteParent.id,
            nom: planeteParent.nom,
            description: planeteParent.description,
            image: planeteParent.image,
            onboardingDescription: planeteParent.onboardingDescription,
            iconOnboarding: planeteParent.iconOnboarding,
            backgroundPlanete: planeteParent.backgroundPlanete
        )
    }
    
    // POST/Planetes/music
    @Sendable
    func createPlaneteMusic(_ req: Request) async throws -> PlaneteDTO {
        let dto = try req.content.decode(PlaneteDTO.self)
        
        if try await Planete.query(on: req.db)
            .filter(\.$nom == dto.nom)
            .first() != nil {
            throw Abort(.badRequest, reason: "Un planete avec ce nom existe déjà")
        }
        
        let planeteParent = Planete(
            id : UUID(),
            nom : dto.nom,
            description: dto.description,
            image: dto.image,
            onboardingDescription: dto.onboardingDescription,
            iconOnboarding : dto.iconOnboarding,
            backgroundPlanete : dto.backgroundPlanete,
            isVisited: false
        )
        
        try await planeteParent.save(on: req.db)
        
        let planeteMusic = PlaneteMusic(
            id: UUID(),
            planeteID: planeteParent.id!
        )
        
        try await planeteMusic.save(on: req.db)
        
        return PlaneteDTO(
            id: planeteParent.id,
            nom: planeteParent.nom,
            description: planeteParent.description,
            image: planeteParent.image,
            onboardingDescription: planeteParent.onboardingDescription,
            iconOnboarding: planeteParent.iconOnboarding,
            backgroundPlanete: planeteParent.backgroundPlanete
        )
    }
    
    // POST/Planetes/philo
    @Sendable
    func createPlanetePhilo(_ req: Request) async throws -> PlaneteDTO {
        let dto = try req.content.decode(PlaneteDTO.self)
        
        if try await Planete.query(on: req.db)
            .filter(\.$nom == dto.nom)
            .first() != nil {
            throw Abort(.badRequest, reason: "Un planete avec ce nom existe déjà")
        }
        
        let planeteParent = Planete(
            id : UUID(),
            nom : dto.nom,
            description: dto.description,
            image: dto.image,
            onboardingDescription: dto.onboardingDescription,
            iconOnboarding : dto.iconOnboarding,
            backgroundPlanete : dto.backgroundPlanete,
            isVisited: false
        )
        
        try await planeteParent.save(on: req.db)
        
        let planetePhilo = PlanetePhilo(
            id: UUID(),
            planeteID: planeteParent.id!
        )
        
        try await planetePhilo.save(on: req.db)
        
        return PlaneteDTO(
            id: planeteParent.id,
            nom: planeteParent.nom,
            description: planeteParent.description,
            image: planeteParent.image,
            onboardingDescription: planeteParent.onboardingDescription,
            iconOnboarding: planeteParent.iconOnboarding,
            backgroundPlanete: planeteParent.backgroundPlanete
        )
    }
    
    // POST/Planetes/mission
    @Sendable
    func createPlaneteMission(_ req: Request) async throws -> PlaneteDTO {
        let dto = try req.content.decode(PlaneteDTO.self)
        
        if try await Planete.query(on: req.db)
            .filter(\.$nom == dto.nom)
            .first() != nil {
            throw Abort(.badRequest, reason: "Un planete avec ce nom existe déjà")
        }
        
        let planeteParent = Planete(
            id : UUID(),
            nom : dto.nom,
            description: dto.description,
            image: dto.image,
            onboardingDescription: dto.onboardingDescription,
            iconOnboarding : dto.iconOnboarding,
            backgroundPlanete : dto.backgroundPlanete,
            isVisited: false
        )
        
        try await planeteParent.save(on: req.db)
        
        let planeteMission = PlaneteMission(
            id: UUID(),
            planeteID: planeteParent.id!
        )
        
        try await planeteMission.save(on: req.db)
        
        return PlaneteDTO(
            id: planeteParent.id,
            nom: planeteParent.nom,
            description: planeteParent.description,
            image: planeteParent.image,
            onboardingDescription: planeteParent.onboardingDescription,
            iconOnboarding: planeteParent.iconOnboarding,
            backgroundPlanete: planeteParent.backgroundPlanete
        )
    }
    
    // POST/Planetes/souvenir
    @Sendable
    func createPlaneteSouvenir(_ req: Request) async throws -> PlaneteDTO {
        let dto = try req.content.decode(PlaneteDTO.self)
        
        if try await Planete.query(on: req.db)
            .filter(\.$nom == dto.nom)
            .first() != nil {
            throw Abort(.badRequest, reason: "Un planete avec ce nom existe déjà")
        }
        
        let planeteParent = Planete(
            id : UUID(),
            nom : dto.nom,
            description: dto.description,
            image: dto.image,
            onboardingDescription: dto.onboardingDescription,
            iconOnboarding : dto.iconOnboarding,
            backgroundPlanete : dto.backgroundPlanete,
            isVisited: false
        )
        
        try await planeteParent.save(on: req.db)
        
        let planeteSouvenir = PlaneteSouvenir(
            id: UUID(),
            planeteID: planeteParent.id!
        )
        
        try await planeteSouvenir.save(on: req.db)
        
        return PlaneteDTO(
            id: planeteParent.id,
            nom: planeteParent.nom,
            description: planeteParent.description,
            image: planeteParent.image,
            onboardingDescription: planeteParent.onboardingDescription,
            iconOnboarding: planeteParent.iconOnboarding,
            backgroundPlanete: planeteParent.backgroundPlanete
        )
    }
    
    //DELETE/Planetes/:id
    @Sendable
    func deletePlaneteById(_ req: Request) async throws -> Response {
        guard let planete = try await Planete.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.badRequest, reason: "Id invalide")
        }
        try await planete.delete(on: req.db)
        return Response(status: .noContent)
    }
    
    //PATCH/Planetes/:id
    @Sendable
    func updatePlaneteById(_ req: Request) async throws -> PlaneteDTO {
        let dto = try req.content.decode(UpdatePlaneteDTO.self)
        
        guard dto.nom != nil ||
                dto.description != nil ||
                dto.image != nil ||
                dto.onboardingDescription != nil ||
                dto.iconOnboarding != nil ||
                dto.backgroundPlanete != nil else {
            throw Abort(.badRequest, reason: "Rien à modifier")
        }
        guard let id = req.parameters.get("id", as : UUID.self),
              let planete = try await Planete.find(id, on: req.db) else
        {
            throw Abort(.notFound)
        }
        if let n = dto.nom { planete.nom = n }
        if let d = dto.description { planete.description = d }
        if let i = dto.image { planete.image = i }
        if let obd = dto.onboardingDescription { planete.onboardingDescription = obd }
        if let io = dto.iconOnboarding { planete.iconOnboarding = io }
        if let bgp = dto.backgroundPlanete { planete.backgroundPlanete = bgp }

        if try await Planete.query(on: req.db)
            .filter(\.$nom == planete.nom)
            .filter(\.$description == planete.description)
            .filter(\.$image == planete.image)
            .filter(\.$onboardingDescription == planete.onboardingDescription)
            .filter(\.$iconOnboarding == planete.iconOnboarding)
            .filter(\.$backgroundPlanete == planete.backgroundPlanete)
            .first() != nil {
            throw Abort(.badRequest, reason: "Un autre planete possède ces attributs")
        }
        try await planete.save(on: req.db)
        return PlaneteDTO(id: planete.id,
                          nom: planete.nom,
                          description: planete.description,
                          image: planete.image,
                          onboardingDescription: planete.onboardingDescription,
                          iconOnboarding: planete.iconOnboarding,
                          backgroundPlanete: planete.backgroundPlanete)
    }
}
