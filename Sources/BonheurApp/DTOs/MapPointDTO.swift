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
    var theme: SouvenirTheme
    var latitude: Double
    var longitude: Double
    var planeteExploId: UUID?
}
