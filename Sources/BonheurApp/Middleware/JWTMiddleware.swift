//
//  JWTMiddleware.swift
//  BonheurApp
//
//  Created by cyrilH on 23/10/2025.
//
import Vapor
import JWT
final class JWTMiddleware: Middleware {
    func respond(to request: Request, chainingTo next: any Responder) -> EventLoopFuture<Response> {
        
        guard let token = request.headers["Authorization"].first?.split(separator: " ").last else {
            return request.eventLoop.future(error: Abort(.unauthorized, reason: "Missing token."))
        }
        let signer = JWTSigner.hs256(key: "IM_BATMAN")
        let payload: UserPayload
        
        do {
            payload = try signer.verify(String(token), as: UserPayload.self)
        } catch {
            return request.eventLoop.future(error: Abort(.unauthorized, reason: "Invalid token"))
        }
        request.auth.login(payload)
        return next.respond(to: request)
        
    }
    
}

