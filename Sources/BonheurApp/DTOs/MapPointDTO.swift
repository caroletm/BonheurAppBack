//
//  MapPointDTO.swift
//  BonheurApp
//
//  Created by cyrilH on 19/10/2025.
//

import Vapor

struct MapPointDTO: Content {
    var id: UUID?
    var nom: String
    var photo : String?
    var theme: SouvenirTheme
    var description: String
    var latitude: Double
    var longitude: Double
    var planeteExploId: UUID?
}
