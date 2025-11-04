//
//  CourPhiloDTO.swift
//  BonheurApp
//
//  Created by Emmanuel on 21/10/2025.
//

import Fluent
import Vapor

struct CourantPhiloDTO: Content {
    var id: UUID?
    var planetePhiloId: UUID?
    var nom: String
    var icon: String
    var description: String
}
// a utiliser dans le cas d'un PUT et PATCH
struct PartialCourantPhilo: Content {
    var texte: String?
}
