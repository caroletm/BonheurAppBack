//
//  CourantPhilo.swift
//  BonheurApp
//
//  Created by caroletm on 14/10/2025.
//

import Vapor
import Fluent

final class CourantPhilo: Model, Content, @unchecked Sendable {
    static let schema = "CourantPhilo"
    
    @ID(key : .id) var id : UUID?
    @Parent(key : "planetePhilo_Id") var planetePhilo : PlanetePhilo
    @Field(key : "nom") var nom : String
    @Field(key : "icon") var icon : String
    @Field(key : "description") var description : String
    
    init() {}
    init(id : UUID, planetePhiloID : PlanetePhilo.IDValue) {
        self.id = id
        self.$planetePhilo.id = planetePhiloID
    }
}
