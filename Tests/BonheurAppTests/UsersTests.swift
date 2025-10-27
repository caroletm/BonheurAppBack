//
//  UsersTests.swift
//  BonheurApp
//
//  Created by cyrilH on 24/10/2025.
//

//import Testing
//import Vapor
//@testable import BonheurApp
//import Fluent
//import FluentSQLiteDriver
//import JWT
//
//
//@Suite("UserController Tests")
//struct UserControllerTests {
//    
//    // MARK: - Helper Methods
//    
//    private func createApp() async throws -> Application {
//        let app = try await Application.make(.testing)
//        try await configure(app)
//        return app
//    }
//    
//    private func createTestUser(on app: Application,
//                                email: String = "test@example.com",
//                                nom: String = "Test User",
//                                motDePasse: String = "password123") async throws -> User {
//        let hashedPassword = try Bcrypt.hash(motDePasse)
//        let user = User(email: email, nom: nom, motDePasse: hashedPassword)
//        try await user.save(on: app.db)
//        return user
//    }
//    
//    private func generateToken(for user: User) throws -> String {
//        let payload = UserPayload(id: user.id!)
//        let signer = JWTSigner.hs256(key: "IM_BATMAN")
//        return try signer.sign(payload)
//    }
//    
//    // MARK: - GET /users Tests
//    
//    @Test("GET /users affiche les utilisateurs")
//    func getAllUsers() async throws {
//        let app = try await createApp()
//        defer { Task { try await app.asyncShutdown() } }
//        
//        _ = try await createTestUser(on: app, email: "user1@example.com", nom: "User One")
//        _ = try await createTestUser(on: app, email: "user2@example.com", nom: "User Two")
//        
//        
//        let res = try await app.sendRequest(.GET, to: "users")
//        #expect(res.status == .ok)
//        
//        let users = try res.content.decode([UserDTO].self)
//        #expect(users.count == 2)
//        #expect(users[0].email == "user1@example.com")
//        #expect(users[1].email == "user2@example.com")
//    }
//    
//    @Test("GET /users retourne une liste vide si aucun utilisateur")
//    func getAllUsersEmpty() async throws {
//        let app = try await createApp()
//        defer { Task { try await app.asyncShutdown() } }
//        
//        let res = try await app.sendRequest(.GET, to: "users") // 🟢 CHANGEMENT
//        #expect(res.status == .ok)
//        
//        let users = try res.content.decode([UserDTO].self)
//        #expect(users.isEmpty)
//    }
//    
//    // MARK: - GET /users/:userID Tests
//    
//    @Test("GET /users/:userID retourne un utilisateur")
//    func getUserById() async throws {
//        let app = try await createApp()
//        defer { Task { try await app.asyncShutdown() } }
//        
//        let user = try await createTestUser(on: app)
//        
//        let res = try await app.sendRequest(.GET, to: "users/\(user.id!)") // 🟢 CHANGEMENT
//        #expect(res.status == .ok)
//        
//        let userDTO = try res.content.decode(UserDTO.self)
//        #expect(userDTO.id == user.id)
//        #expect(userDTO.email == "test@example.com")
//        #expect(userDTO.nom == "Test User")
//    }
//    
//    @Test("GET /users/:userID retourne 404 si utilisateur inexistant")
//    func getUserByIdNotFound() async throws {
//        let app = try await createApp()
//        defer { Task { try await app.asyncShutdown() } }
//        
//        let randomUUID = UUID()
//        let res = try await app.sendRequest(.GET, to: "users/\(randomUUID)") // 🟢 CHANGEMENT
//        #expect(res.status == .notFound)
//    }
//    
//    // MARK: - POST /users Tests
//    
//    @Test("POST /users crée un nouvel utilisateur")
//    func createUser() async throws {
//        let app = try await createApp()
//        defer { Task { try await app.asyncShutdown() } }
//        
//        let newUser = UserDTO(id: nil, email: "newuser@example.com", nom: "New User", motDePasse: "password123")
//        
//        // 🟢 CHANGEMENT : créer le body manuellement
//        let body = try ByteBuffer(data: JSONEncoder().encode(newUser))
//        let res = try await app.sendRequest(.POST, to: "users", body: body)
//        
//        #expect(res.status == .ok)
//        
//        let createdUser = try res.content.decode(UtilisateurDTO.self)
//        #expect(createdUser.email == "newuser@example.com")
//        #expect(createdUser.nom == "New User")
//        #expect(createdUser.id != nil)
//        
//        let userFromDB = try await User.find(createdUser.id, on: app.db)
//        #expect(userFromDB != nil)
//    }
//    
//    @Test("POST /users hash le mot de passe")
//    func createUserHashesPassword() async throws {
//        let app = try await createApp()
//        defer { Task { try await app.asyncShutdown() } }
//        
//        let newUser = UserDTO(id: nil, email: "secure@example.com", nom: "Secure User", motDePasse: "plainPassword")
//        let body = try ByteBuffer(data: JSONEncoder().encode(newUser)) // 🟢 CHANGEMENT
//        let res = try await app.sendRequest(.POST, to: "users", body: body)
//        
//        #expect(res.status == .ok)
//        let createdUser = try res.content.decode(UtilisateurDTO.self)
//        let userFromDB = try await User.find(createdUser.id, on: app.db)
//        
//        #expect(userFromDB?.motDePasse != "plainPassword")
//        let isValid = try Bcrypt.verify("plainPassword", created: userFromDB!.motDePasse)
//        #expect(isValid)
//    }
//    
//    // MARK: - POST /users/login Tests
//    
//    @Test("POST /users/login retourne un token valide")
//    func loginSuccess() async throws {
//        let app = try await createApp()
//        defer { Task { try await app.asyncShutdown() } }
//        
//        _ = try await createTestUser(on: app, email: "login@example.com", motDePasse: "password123")
//        
//        let loginData = loginRequest(email: "login@example.com", motDePasse: "password123")
//        let body = try ByteBuffer(data: JSONEncoder().encode(loginData)) // 🟢 CHANGEMENT
//        let res = try await app.sendRequest(.POST, to: "users/login", body: body)
//        
//        #expect(res.status == .ok)
//        let token = try res.content.decode(String.self)
//        #expect(!token.isEmpty)
//        
//        let signer = JWTSigner.hs256(key: "IM_BATMAN")
//        let payload = try signer.verify(token, as: UserPayload.self)
//        #expect(!payload.id.uuidString.isEmpty)
//    }
//    
//    @Test("POST /users/login échoue avec email incorrect")
//    func loginFailsWithWrongEmail() async throws {
//        let app = try await createApp()
//        defer { Task { try await app.asyncShutdown() } }
//        
//        _ = try await createTestUser(on: app, email: "correct@example.com", motDePasse: "password123")
//        
//        let loginData = loginRequest(email: "wrong@example.com", motDePasse: "password123")
//        let body = try ByteBuffer(data: JSONEncoder().encode(loginData))
//        let res = try await app.sendRequest(.POST, to: "users/login", body: body)
//        #expect(res.status == .unauthorized)
//    }
//    
//    @Test("POST /users/login échoue avec mot de passe incorrect")
//    func loginFailsWithWrongPassword() async throws {
//        let app = try await createApp()
//        defer { Task { try await app.asyncShutdown() } }
//        
//        _ = try await createTestUser(on: app, email: "test@example.com", motDePasse: "correctPassword")
//        
//        let loginData = loginRequest(email: "test@example.com", motDePasse: "wrongPassword")
//        let body = try ByteBuffer(data: JSONEncoder().encode(loginData))
//        let res = try await app.sendRequest(.POST, to: "users/login", body: body)
//        #expect(res.status == .unauthorized)
//    }
//    
//    // MARK: - GET /users/profile Tests
//    
//    @Test("GET /users/profile retourne le profil de l'utilisateur authentifié")
//    func getProfile() async throws {
//        let app = try await createApp()
//        defer { Task { try await app.asyncShutdown() } }
//        
//        let user = try await createTestUser(on: app)
//        let token = try generateToken(for: user)
//        
//        var headers = HTTPHeaders()
//        headers.add(name: .authorization, value: "Bearer \(token)")
//        
//        let res = try await app.sendRequest(.GET, to: "users/profile", headers: headers)
//        #expect(res.status == .ok)
//        
//        let profile = try res.content.decode(UtilisateurDTO.self)
//        #expect(profile.email == "profile@example.com")
//    }
//    
//    @Test("GET /users/profile échoue sans token")
//    func getProfileFailsWithoutToken() async throws {
//        let app = try await createApp()
//        defer { Task { try await app.asyncShutdown() } }
//        
//        let res = try await app.sendRequest(.GET, to: "users/profile")
//        #expect(res.status == .unauthorized)
//    }
//    
//    // MARK: - DELETE /users/:userID Tests
//    
//    @Test("DELETE /users/:userID supprime un utilisateur")
//    func deleteUser() async throws {
//        let app = try await createApp()
//        defer { Task { try await app.asyncShutdown() } }
//        
//        let user = try await createTestUser(on: app)
//        let res = try await app.sendRequest(.DELETE, to: "users/\(user.id!)") // 🟢 CHANGEMENT
//        #expect(res.status == .noContent)
//        
//        let deletedUser = try await User.find(user.id, on: app.db)
//        #expect(deletedUser == nil)
//    }
//    
//    @Test("DELETE /users/:userID retourne 404 si utilisateur inexistant")
//    func deleteUserNotFound() async throws {
//        let app = try await createApp()
//        defer { Task { try await app.asyncShutdown() } }
//        
//        let randomUUID = UUID()
//        let res = try await app.sendRequest(.DELETE, to: "users/\(randomUUID)") // 🟢 CHANGEMENT
//        #expect(res.status == .notFound)
//    }
//}
//
//// MARK: - Helper Struct
//
//struct loginRequest: Content {
//    let email: String
//    let motDePasse: String
//}
//
//// MARK: - Helper HTTP function
//
//extension Application {
//    /// Envoie une requête HTTP et retourne la réponse (compatible Vapor 4)
//    func sendRequest(
//        _ method: HTTPMethod,
//        to path: String,
//        headers: HTTPHeaders = [:],
//        body: ByteBuffer? = nil
//    ) async throws -> Response {
//        // 🟢 Ajout du paramètre 'on:'
//        let request = Request(
//            application: self,
//            method: method,
//            url: URI(path: path),
//            headers: headers,
//            collectedBody: body.map { .init(buffer: $0) },
//            on: self.eventLoopGroup.next()
//        )
//        
//        // 🟢 Dans Vapor 4, `respond(to:)` renvoie un EventLoopFuture<Response>
//        // donc on utilise `.get()` pour attendre le résultat
//        return try await request.application.responder.respond(to: request).get()
//    }
//}
