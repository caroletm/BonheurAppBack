//
//  Untitled.swift
//  BonheurApp
//
//  Created by cyrilH on 19/10/2025.
//

import Vapor

struct MissionDTO: Content {
    var id: UUID?
    var nom: String
    var planeteMissionId: UUID?
    var isValidated: Bool?
    var souvenirId: UUID?
}

struct PartialMissionDTO: Content {
    var nom: String?
   
}

