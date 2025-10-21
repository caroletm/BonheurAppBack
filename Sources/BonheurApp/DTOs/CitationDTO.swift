//
//  citationDTO.swift
//  BonheurApp
//
//  Created by Emmanuel on 20/10/2025.
//

import Fluent
import Vapor

struct CitationDTO: Content {
    var id: UUID?
    var texte: String
}
// a utiliser dans le cas d'un PUT et PATCH
struct PartialCitationDTO: Content {
    var texte: String?
}
    
