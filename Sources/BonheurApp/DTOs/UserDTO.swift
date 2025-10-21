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
