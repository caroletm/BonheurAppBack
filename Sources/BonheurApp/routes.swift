import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }

//    try app.register(collection: TodoController())
    try app.register(collection: CitationController())

    try app.register(collection: SouvenirController())
    try app.register(collection: MissionController())
    try app.register(collection: MapPointController())
    try app.register(collection: VisiteController())
    try app.register(collection: UserController())
    
    
}
