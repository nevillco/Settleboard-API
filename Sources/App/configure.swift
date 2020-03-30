import FluentPostgreSQL
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // Register providers first
    try services.register(FluentPostgreSQLProvider())

    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    // middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    // Register Postgres DB
    var databases = DatabasesConfig()
    let config: PostgreSQLDatabaseConfig
    if let url = Environment.get("DATABASE_URL") {
        config = PostgreSQLDatabaseConfig(url: url, transport: .unverifiedTLS)!
    } else {
        config = PostgreSQLDatabaseConfig(hostname: "localhost", username: "connorneville", database: "settleboard")
    }
    databases.add(database: PostgreSQLDatabase(config: config), as: .psql)
    services.register(databases)

    var commands = CommandConfig.default()
    commands.useFluentCommands()
    services.register(commands)

    // Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: User.self, database: .psql)
    migrations.add(model: Match.self, database: .psql)
    migrations.add(model: Score.self, database: .psql)
    services.register(migrations)
}
