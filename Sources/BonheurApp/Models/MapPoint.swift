//
//  MapPoint.swift
//  BonheurApp
//
//  Created by caroletm on 14/10/2025.
//

import Vapor
import Fluent

final class MapPoint : Model, Content, @unchecked Sendable {
    static let schema = "MapPoint"
    
    @ID(key : .id) var id: UUID?
    @Parent(key: "planeteExplo_Id") var planeteExplo: PlaneteExplo
    @Field(key : "nom") var nom : String
    @Field(key: "theme") var theme : SouvenirTheme
    @Field(key : "latitude") var latitude: Double
    @Field(key : "longitude") var longitude: Double
    @OptionalChild(for : \.$mapPoint) var souvenirMap : SouvenirMap?
    
    init() {}
    init(id: UUID, planeteExploID: PlaneteExplo.IDValue, nom: String, theme: SouvenirTheme, latitude: Double, longitude: Double) {
        self.id = id
        self.$planeteExplo.id = planeteExploID
        self.nom = nom
        self.theme = theme
        self.latitude = latitude
        self.longitude = longitude
    }
}
