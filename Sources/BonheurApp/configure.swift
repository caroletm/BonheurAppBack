import NIOSSL
import Fluent
import FluentMySQLDriver
import Vapor
import FluentSQL
import JWT
import FluentSQLiteDriver

// configures your application
public func configure(_ app: Application) async throws {
    
    if app.environment == .testing {
        app.databases.use(.sqlite(.memory), as: .sqlite)
    } else {
        app.databases.use(DatabaseConfigurationFactory.mysql(
            hostname: Environment.get("DATABASE_HOST") ?? "localhost",
            port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? 3306,
            username: Environment.get("DATABASE_USERNAME") ?? "root",
            password: Environment.get("DATABASE_PASSWORD") ?? "",
            database: Environment.get("DATABASE_NAME") ?? "BonheurApp"
        ), as: .mysql)
    }
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    

//    app.migrations.add(CreateTodo())
    
    app.migrations.add(CreateUser())
    app.migrations.add(UpdateUser())
    app.migrations.add(CreatePlanete())
    app.migrations.add(CreatePlaneteExplo())
    app.migrations.add(CreatePlaneteMusic())
    app.migrations.add(CreatePlanetePhilo())
    app.migrations.add(CreatePlaneteMission())
    app.migrations.add(CreatePlaneteSouvenir())
    app.migrations.add(CreateCitation())
    app.migrations.add(CreateSouvenir())
    app.migrations.add(CreateSouvenirDefi())
    app.migrations.add(CreateSouvenirMap())
    app.migrations.add(CreateMission())
    app.migrations.add(CreateMapPoint())
    app.migrations.add(CreateMusic())
    app.migrations.add(CreatePhilo())
    app.migrations.add(UpdateSouvenirMap())
    app.migrations.add(UpdateSouvenirDefi())
    app.migrations.add(UpdatePlaneteSouvenir2())
    app.migrations.add(UpdatePlaneteSouvenir3())
    app.migrations.add(UpdatePlaneteExplo())
    app.migrations.add(UpdatePlaneteExplo2())
    app.migrations.add(UpdatePlaneteMusic())
    app.migrations.add(UpdatePlaneteMusic2())
    app.migrations.add(UpdatePlaneteMission())
    app.migrations.add(UpdatePlaneteMission2())
    app.migrations.add(UpdatePlanetePhilo())
    app.migrations.add(UpdatePlanetePhilo2())
    app.migrations.add(UpdateMapPoint())
    app.migrations.add(UpdateMission())
    app.migrations.add(CreateVisite2())
//    app.migrations.add(CreateVisiteTest())
    app.migrations.add(UpdateVisite())
    app.migrations.add(UpdateMapPoint2())
    app.migrations.add(AddRoleToUser())
    app.migrations.add(UpdateSouvenirMap2())
    app.migrations.add(UpdateSouvenirMap3())
    app.migrations.add(UpdateSouvenirMap4())
    app.migrations.add(DeleteTableMapPoint())
    app.migrations.add(UpdateMapPoint3())
    app.migrations.add(UpdateSouvenirFromUser())
    
//    app.migrations.add(DeleteSouvenirMapIdFromMapPoint())
    
    try await app.autoMigrate()
    
    //Test rapide de connexion
    if let sql = app.db(.mysql) as? (any SQLDatabase) {
        sql.raw("SELECT 1").run().whenComplete { response in
            print(response)
        }
    } else {
        print("⚠️ Le driver SQL n'est pas disponible (cast vers SQLDatabase impossible)")
    }

    // register routes
    try routes(app)
}
