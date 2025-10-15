//
//  Mission.swift
//  BonheurApp
//
//  Created by caroletm on 15/10/2025.
//

import Vapor
import Fluent

final class Mission: Model, Content, @unchecked Sendable {
    static let schema = "Mission"
    
    @ID(key: .id) var id: UUID?
    @Parent(key: "planeteMission_Id") var planeteMission: PlaneteMission
    @Field(key : "nom") var nom : String
    @OptionalChild(for : \.$mission) var souvenirDefi : SouvenirDefi?

    
    init() {}
    init(id: UUID, planeteMissionID: PlaneteMission.IDValue) {
        self.id = id
        self.$planeteMission.id = planeteMissionID
    }
    
}
