//
//  SouvenirDTO.swift
//  BonheurApp
//
//  Created by cyrilH on 19/10/2025.
//
import Vapor

struct SouvenirDTO: Content {
    var id: UUID?
    var nom: String
    var photo: String?
    var description: String
    var theme: SouvenirTheme
    var type: SouvenirType
    var date: Date?
}

struct UpdateSouvenirDTO: Content {
    var nom: String?
    var photo: String?
    var description: String?
    var theme: SouvenirTheme?
    var type: SouvenirType?
    var date: Date?
}
