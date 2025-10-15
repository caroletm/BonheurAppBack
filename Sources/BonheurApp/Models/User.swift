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
    @Children(for : \.$user) var visite: [Visite]

    
    init() {}
    init(email : String, nom : String, motDePasse : String) {
        self.email = email
        self.nom = nom
        self.motDePasse = motDePasse
    }
}
