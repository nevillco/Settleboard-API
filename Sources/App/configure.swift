import Authentication
import FluentPostgreSQL
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // Register providers first
    try services.register(FluentPostgreSQLProvider())
    try services.register(AuthenticationProvider())

    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    var middlewares = MiddlewareConfig()
    middlewares.use(ErrorMiddleware.self)
    services.register(middlewares)

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

    var migrations = MigrationConfig()
    migrations.add(model: User.self, database: .psql)
    migrations.add(model: Match.self, database: .psql)
    migrations.add(model: MatchUser.self, database: .psql)
    services.register(migrations)
}
