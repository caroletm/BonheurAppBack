//
//  VisiteDTO.swift
//  BonheurApp
//
//  Created by cyrilH on 19/10/2025.
//

import Vapor

struct VisiteDTO: Content {
    var id: UUID?
    var dateTime: Date?
    var userId: UUID
    var planeteId: UUID
}
