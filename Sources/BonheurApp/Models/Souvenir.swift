//
//  Souvenir.swift
//  BonheurApp
//
//  Created by caroletm on 14/10/2025.
//

import Vapor
import Fluent

final class Souvenir : Model, Content, @unchecked Sendable {
    static let schema = "Souvenir"
    
    @ID(key: .id) var id: UUID?
    @Field(key: "nom") var nom: String
    @Field(key: "photo") var photo: String
    @Field(key: "description") var description: String
    @Timestamp(key: "date", on: .create) var date: Date?
    @Enum(key: "theme") var theme: SouvenirTheme
    @Enum(key: "type") var type: SouvenirType
    @Parent(key: "user_Id") var user: User
    @Parent(key : "planeteSouvenir_Id") var planeteSouvenir : PlaneteSouvenir
    @OptionalChild(for : \.$souvenir) var souvenirsDefi: SouvenirDefi?
    @OptionalChild(for : \.$souvenir) var souvenirsMap: SouvenirMap?
    
    
    init() {}
    init(id: UUID? = nil, nom: String, photo: String, description: String, theme: SouvenirTheme, type: SouvenirType ,userId: User.IDValue,planeteSouvenirId: PlaneteSouvenir.IDValue) {
        self.id = id
        self.nom = nom
        self.photo = photo
        self.description = description
        self.theme = theme
        self.type = type
        self.$user.id = userId
        self.$planeteSouvenir.id = planeteSouvenirId
    }
}

final class SouvenirDefi: Model, Content, @unchecked Sendable {
    static let schema = "SouvenirDefi"
    
    @ID(key: .id) var id: UUID?
    @Field(key: "isValidated") var isValidated: Bool
    @Parent(key: "souvenirId") var souvenir: Souvenir
    @Parent(key: "souvenirDefi_Id") var mission: Mission
    
    init() {}
    init(id: UUID? = nil, isValidated: Bool, souvenirID: Souvenir.IDValue, missionID : Mission.IDValue) {
        self.id = id
        self.isValidated = isValidated
        self.$souvenir.id = souvenirID
        self.$mission.id = missionID
    }
}

final class SouvenirMap : Model, Content, @unchecked Sendable {
    static let schema = "SouvenirMap"
    
    @ID(key: .id) var id: UUID?
    @Field(key: "latitude") var latitude: Double
    @Field(key: "longitude") var longitude: Double
    @Parent(key: "souvenirId") var souvenir: Souvenir
    @Parent(key: "souvenirMap_Id") var mapPoint: MapPoint
    
    init() {}
    init(id: UUID? = nil, latitude: Double, longitude: Double, souvenirID: Souvenir.IDValue, mapPointID : MapPoint.IDValue) {
        
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.$souvenir.id = souvenirID
        self.$mapPoint.id = mapPointID
    }
}

