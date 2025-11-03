// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "BonheurApp",
    platforms: [
        .macOS(.v13)
    ],
    dependencies: [
        // 💧 Vapor
        .package(url: "https://github.com/vapor/vapor.git", from: "4.115.0"),
        // 🗄 Fluent + drivers
        .package(url: "https://github.com/vapor/fluent.git", from: "4.9.0"),
        .package(url: "https://github.com/vapor/fluent-mysql-driver.git", from: "4.4.0"),
        .package(url: "https://github.com/vapor/fluent-sqlite-driver.git", from: "4.5.0"),
        // 🔵 Swift NIO
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.65.0"),
        // 🔐 JWT
        .package(url: "https://github.com/vapor/jwt.git", from: "4.0.0"),
        . package (url: "https://github.com/nodes-vapor/gatekeeper.git", from: "4.0.0"),
        // 🧪 XCTVapor pour les tests
//        .package(url: "https://github.com/vapor/xctvapor.git", from: "1.5.0"),
            
    ],
    targets: [
        .executableTarget(
            name: "BonheurApp",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentMySQLDriver", package: "fluent-mysql-driver"),
                .product(name: "FluentSQLiteDriver", package: "fluent-sqlite-driver"),
                .product(name: "JWT", package: "jwt"),
                .product(name: "NIOCore", package: "swift-nio"),
                .product(name: "NIOPosix", package: "swift-nio"),
                .product (name: "Gatekeeper", package: "gatekeeper"),
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "BonheurAppTests",
            dependencies: [
                .target(name: "BonheurApp"),
                .product(name: "Vapor", package: "vapor"),
                .product(name: "FluentSQLiteDriver", package: "fluent-sqlite-driver"),
//                .product(name: "XCTVapor", package: "xctvapor"), 
            ],
            swiftSettings: swiftSettings
        )
    ]
)

var swiftSettings: [SwiftSetting] { [
    .enableUpcomingFeature("ExistentialAny"),
] }
