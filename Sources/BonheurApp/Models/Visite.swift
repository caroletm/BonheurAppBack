//
//  Visite.swift
//  BonheurApp
//
//  Created by caroletm on 15/10/2025.
//

import Fluent

import Vapor
import Fluent

final class Visite : Model, Content, @unchecked Sendable {
    static let schema = "visite"
    
    @ID(key: .id) var id: UUID?
    @Timestamp(key: "dateTime", on: .create) var dateTime: Date?
    @Parent(key: "user_Id") var user: User
    @Parent(key: "planete_Id") var planete: Planete

    init() {}
    init(id : UUID, dateTime : Date, userID : User.IDValue, planeteID : Planete.IDValue) {
        self.id = id
        self.dateTime = dateTime
        self.$user.id = userID
        self.$planete.id = planeteID
    }
}
