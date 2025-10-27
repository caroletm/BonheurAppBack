//
//  UserTokenPayload.swift
//  BonheurApp
//
//  Created by cyrilH on 23/10/2025.
//
import Foundation
import Vapor
import JWT

struct UserPayload: JWTPayload, Authenticatable {
    var id: UUID
    var expiration: Date
    func verify(using signer: JWTSigner) throws {
        guard expiration > Date() else {
            throw Abort(.unauthorized,reason: "Token expired")
        }
    }
    init(id:UUID) {
        self.id = id
        self.expiration = Date().addingTimeInterval(3600 * 72)
    }
}
