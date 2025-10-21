//
//  Citation.swift
//  BonheurApp
//
//  Created by caroletm on 14/10/2025.
//

import Vapor
import Fluent

final class Citation : Model, Content, @unchecked Sendable {
    static let schema = "Citation"
    
    @ID(key: .id) var id: UUID?
    @Field(key: "text") var text: String
    
    init() {}
    init(id : UUID? = nil, text: String) {
        
        self.id = id
        self.text = text
    }
}
