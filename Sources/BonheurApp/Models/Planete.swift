//
//  Planete.swift
//  BonheurApp
//
//  Created by caroletm on 14/10/2025.
//

import Vapor
import Fluent

final class Planete : Model, Content, @unchecked Sendable {
    static let schema = "Planete"
    
    @ID(key: .id) var id: UUID?
    @Field(key: "nom") var nom: String
    @Field(key: "description") var description: String
    @Field(key: "image") var image: String
    @Field(key: "onboardingDescription") var onboardingDescription: String
    @Field(key: "iconOnboarding") var iconOnboarding: String
    @Field(key: "backgroundPlanete") var backgroundPlanete: String
    @Field(key: "isVisited") var isVisited: Bool
    @Children(for : \.$planete) var planeteExplo: [PlaneteExplo]
    @Children(for : \.$planete) var planeteMusic: [PlaneteMusic]
    @Children(for : \.$planete) var planetePhilo: [PlanetePhilo]
    @Children(for : \.$planete) var planeteMission: [PlaneteMission]
    @Children(for : \.$planete) var planeteSouvenir: [PlaneteSouvenir]
    @Children(for : \.$planete) var visite: [Visite]

    init() {}
    init(id : UUID, nom: String, description: String, image: String, onboardingDescription: String, iconOnboarding: String, backgroundPlanete: String, isVisited: Bool) {
        
        self.id = id
        self.nom = nom
        self.description = description
        self.image = image
        self.onboardingDescription = onboardingDescription
        self.iconOnboarding = iconOnboarding
        self.backgroundPlanete = backgroundPlanete
        self.isVisited = isVisited
    }
}

final class PlaneteExplo: Model, Content, @unchecked Sendable {
    static let schema = "PlaneteExplo"
    
    @ID(key: .id) var id: UUID?
    @Parent(key: "planeteId") var planete: Planete
    
    @Children(for: \.$planeteExplo) var mapPoints: [MapPoint]

    init() {}
    init(id: UUID, planeteID: Planete.IDValue) {
        self.id = id
        self.$planete.id = planeteID
    }
}



final class PlaneteMusic: Model, Content, @unchecked Sendable {
    static let schema = "PlaneteMusic"
    
    @ID(key: .id) var id: UUID?
    @Parent(key: "planeteId") var planete: Planete
    
    @Children(for : \.$planeteMusic) var musiques: [Musique]
    
    init() {}
    init(id: UUID, planeteID: Planete.IDValue) {
        self.id = id
        self.$planete.id = planeteID
    }
}



final class PlaneteMission: Model, Content, @unchecked Sendable {
    static let schema = "PlaneteMission"
    
    @ID(key: .id) var id: UUID?
    @Parent(key: "planeteId") var planete: Planete
    
    @Children(for : \.$planeteMission) var missions: [Mission]
    
    init() {}
    init(id: UUID, planeteID: Planete.IDValue) {
        self.id = id
        self.$planete.id = planeteID
    }
}

final class PlanetePhilo: Model, Content, @unchecked Sendable {
    static let schema = "PlanetePhilo"
    
    @ID(key: .id) var id: UUID?
    @Parent(key: "planeteId") var planete: Planete
    
    @Children(for : \.$planetePhilo) var courantPhilo: [CourantPhilo]

    
    init() {}
    init(id: UUID, planeteID: Planete.IDValue) {
        self.id = id
        self.$planete.id = planeteID
    }
}

final class PlaneteSouvenir: Model, Content, @unchecked Sendable {
    static let schema = "PlaneteSouvenir"
    
    @ID(key: .id) var id: UUID?
    @Parent(key: "planeteId") var planete: Planete
    
    @Children(for : \.$planeteSouvenir) var souvenirs: [Souvenir]

    init() {}
    init(id: UUID, planeteID: Planete.IDValue) {
        self.id = id
        self.$planete.id = planeteID
    }
}

