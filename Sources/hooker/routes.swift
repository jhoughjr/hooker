import Fluent
import Vapor
import ShellOut

func routes(_ app: Application) throws {
    
    app.get { req async throws in
        try await req.view.render("index", ["title": "Hello Vapor!",
                                            "frontend_link" : "http://jimmyhoughjr.freeddns.org:8082/AMOS.zip",])
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
        Task {
            print("Pulling...")
            let pullResult = try shellOut(to: .gitPull())
            let bildResult = try shellOut(to: .buildSwiftPackage())
            req.logger.info("\(pullResult) \(bildResult)")
        }
        return ""
    }
    
  
    
    try app.register(collection: TodoController())
}
