//
//  User.swift
//  BonheurApp
//
//  Created by caroletm on 14/10/2025.
//

import Vapor
import Fluent

final class User : Model, Content, @unchecked Sendable {
    static let schema = "users"
    
    @ID(key: .id) var id: UUID?
    @Field(key: "email") var email: String
    @Field(key: "nom") var nom: String
    @Field(key: "motDePasse") var motDePasse: String
    @Enum(key: "role") var role: UserRole
    @Children(for : \.$user) var visites: [Visite]
    @Children(for : \.$user) var souvenirs: [Souvenir]

    
    init() {
        
    }
    init(id: UUID? = nil, email : String, nom : String, motDePasse : String, role: UserRole = .user) {
        self.id = id ?? UUID()
        self.email = email
        self.nom = nom
        self.motDePasse = motDePasse
        self.role = role
    }
    
    func toDTO() -> UtilisateurDTO{
        return UtilisateurDTO(
            id: self.id,
            email: self.email,
            nom: self.nom)
    }
}
