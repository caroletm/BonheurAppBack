//
//  UserController.swift
//  BonheurApp
//
//  Created by cyrilH on 19/10/2025.
//

import Vapor
import Fluent
import JWT

struct UserController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
            let users = routes.grouped("users")
                users.get(use: getAll)
                users.post(use: create)
                users.post("login", use: login)
        
            let protectedRoutes = users.grouped(JWTMiddleware())
                protectedRoutes.get("profile", use : profile)
                protectedRoutes.put(":userID", use: update)
                protectedRoutes.patch(":userID", use: patch)
        
            users.group(":userID"){ user in
                user.get( use: getById)
                user.delete( use: delete)
            }
        
            
        }
    
    @Sendable
    func login(req: Request) async throws -> String {
        let userData = try req.content.decode(loginRequest.self)
        
        guard let user = try await User.query(on: req.db)
            .filter(\.$email == userData.email)
            .first() else {
            throw Abort(.unauthorized, reason: "l' utilisateur nexiste pas")
        }
        guard try Bcrypt.verify(userData.motDePasse, created: user.motDePasse) else {
            throw Abort (.unauthorized, reason: "Mot de passe incorrect")
        }
        let payload = UserPayload(id: user.id!)
        let signer = JWTSigner.hs256(key: "IM_BATMAN")
        let tokene = try signer.sign(payload)
        return tokene
    }
    
    @Sendable
    func profile(req: Request) async throws -> UtilisateurDTO {
        let payload = try req.auth.require(UserPayload.self)
        
        guard let user = try await User.find(payload.id, on: req.db) else {
            throw Abort(.notFound)
        }
        return user.toDTO()
    }
    
    
    
    
    // GET /users
    func getAll(req: Request) async throws -> [UserDTO] {
        let users = try await User.query(on: req.db).all()
        return users.map { UserDTO(id: $0.id, email: $0.email, nom: $0.nom, motDePasse: $0.motDePasse) }
    }
    
    // GET /users/:userID
    func getById(req: Request) async throws -> UserDTO {
        guard let user = try await User.find(req.parameters.get("userID"), on: req.db) else {
            throw Abort(.notFound, reason: "User not found")
        }
        return UserDTO(id: user.id, email: user.email, nom: user.nom, motDePasse: user.motDePasse
)
    }
    
    // POST /users
    func create(req: Request) async throws -> UtilisateurDTO {
        let user = try req.content.decode(User.self)
        user.motDePasse = try Bcrypt.hash(user.motDePasse)
        try await user.save(on: req.db)
        return user.toDTO()
    }
    
    //PUT /users/:userID
    
    func update (req: Request) async throws -> UserDTO {
        guard let user = try await User.find(req.parameters.get("userID"), on:req.db) else {
            throw Abort(.notFound, reason: "User not found")
        }
        let dto = try req.content.decode(UserDTO.self)
        user.email = dto.email
        user.nom = dto.nom
        user.motDePasse = dto.motDePasse
        try await user.update(on: req.db)
        return UserDTO(id: user.id, email: user.email, nom: user.nom, motDePasse: user.motDePasse)
    }
    
    //PATCH/users/:userId
    func patch(req: Request) async throws -> UserDTO{
        guard let user = try await User.find(req.parameters.get("userID"), on: req.db) else {
            throw Abort (.notFound,reason: "User not found")
        }
        let dto = try req.content.decode(PartialUserDTO.self)
        if let email = dto.email{user.email = email}
        if let nom  = dto.nom{user.nom = nom}
        if let motDePasse = dto.motDePasse{user.motDePasse = motDePasse}
        try await user.update(on: req.db)
        return UserDTO(id: user.id, email: user.email, nom: user.nom, motDePasse: user.motDePasse)
    }
    
    
    // DELETE /users/:userID
    func delete(req: Request) async throws -> HTTPStatus {
        guard let user = try await User.find(req.parameters.get("userID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await user.delete(on: req.db)
        return .noContent
    }
}
