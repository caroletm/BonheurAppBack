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
    @Children(for : \.$souvenir) var souvenirsDefi: [SouvenirDefi]
    @Children(for : \.$souvenir) var souvenirsMap: [SouvenirMap]
    
    
    init() {}
    init(id: UUID, nom: String, photo: String, description: String, theme: SouvenirTheme, type: SouvenirType) {
        self.id = id
        self.nom = nom
        self.photo = photo
        self.description = description
        self.theme = theme
        self.type = type
    }
}

final class SouvenirDefi: Model, Content, @unchecked Sendable {
    static let schema = "SouvenirDefi"
    
    @ID(key: .id) var id: UUID?
    @Field(key: "isValidated") var isValidated: Bool
    @Parent(key: "souvenirId") var souvenir: Souvenir
    
    init() {}
    init(id: UUID, isValidated: Bool, souvenirID: Souvenir.IDValue) {
        self.id = id
        self.isValidated = isValidated
        self.$souvenir.id = souvenirID
    }
}

final class SouvenirMap : Model, Content, @unchecked Sendable {
    static let schema = "SouvenirMap"
    
    @ID(key: .id) var id: UUID?
    @Field(key: "latitude") var latitude: Double
    @Field(key: "longitude") var longitude: Double
    @Parent(key: "souvenirId") var souvenir: Souvenir
    
    init() {}
    init(id: UUID, latitude: Double, longitude: Double, souvenirID: Souvenir.IDValue) {
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.$souvenir.id = souvenirID
    }
}

