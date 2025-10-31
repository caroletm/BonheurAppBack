//
//  souvenirDefiDTO.swift
//  BonheurApp
//
//  Created by cyrilH on 30/10/2025.
//
import Vapor

struct SouvenirDefiDTO: Content {
    var id: UUID?
    var nom: String
    var photo : String?
    var theme: SouvenirTheme
    var description: String
    var planetedMission: UUID?
}

struct VisiteCreateDTO: Content {
        var planeteId: UUID
}
