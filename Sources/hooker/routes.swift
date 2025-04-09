import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async throws in
        try await req.view.render("index", ["title": "Hello Vapor!"])
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }

    app.get("webhooks") { req async -> String in
        req.logger.info("post webhooks \(req.body)")
        return ""
    }
    
    app.post("webhooks") { req async -> String in
        req.logger.info("post webhooks \(req.body)")
        return ""
    }
    
    try app.register(collection: TodoController())
}
