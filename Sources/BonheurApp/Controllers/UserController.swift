//
//  UserController.swift
//  BonheurApp
//
//  Created by cyrilH on 19/10/2025.
//

import Vapor
import Fluent

struct UserController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
            let users = routes.grouped("users")
            users.get(use: getAll)
            users.get(":userID", use: getById)
            users.post(use: create)
            users.put(":userID", use: update)
            users.patch(":userID", use: patch)
            users.delete(":userID", use: delete)
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
        return UserDTO(id: user.id, email: user.email, nom: user.nom, motDePasse: user.motDePasse)
    }
    
    // POST /users
    func create(req: Request) async throws -> UserDTO {
        let dto = try req.content.decode(UserDTO.self)
        let user = User(email: dto.email, nom: dto.nom, motDePasse: dto.motDePasse)
        try await user.save(on: req.db)
        return UserDTO(id: user.id, email: user.email, nom: user.nom, motDePasse: user.motDePasse)
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
