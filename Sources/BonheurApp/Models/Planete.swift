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
