//
//  UserDTO.swift
//  BonheurApp
//
//  Created by cyrilH on 19/10/2025.
//
import Vapor

struct UserDTO: Content {
    var id: UUID?
    var email: String
    var nom: String
    var motDePasse: String
}

struct PartialUserDTO: Content {
    var email: String?
    var nom: String?
    var motDePasse: String?
}
struct UtilisateurDTO: Content{
    let id: UUID?
    let email: String
    let nom: String
    func toModel() -> User{
        return User(id: id, email: email, nom: nom, motDePasse: "default")
    }
    
}

