//
//  Musique.swift
//  BonheurApp
//
//  Created by caroletm on 15/10/2025.
//

import Vapor
import Fluent

final class Musique: Model, Content, @unchecked Sendable {
    static let schema = "Musique"
    
    @ID(key: .id) var id: UUID?
    @Parent(key: "planeteMusic_Id") var planeteMusic: PlaneteMusic
    @Field(key : "nom") var nom : String
    @Field(key : "audio") var audio : String
    @Field(key : "logo") var logo : String
    
    init() {}
    init(id : UUID, planeteMusicID : PlaneteMusic.IDValue, nom : String, audio : String, logo : String) {
        self.id = id
        self.$planeteMusic.id = planeteMusicID
        self.nom = nom
        self.audio = audio
        self.logo = logo
    }
}
