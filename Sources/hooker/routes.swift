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
        Task {
            try await executeProcessAndReturnResult("swift -v")
        }
        
        return ""
    }
    
    func executeProcessAndReturnResult(_ command: String) -> String {
        let process = Process()
        let pipe = Pipe()
        let environment = [
            "TERM": "xterm",
            "HOME": "/Users/example-user/",
            "PATH": "/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
        ]
        process.standardOutput = pipe
        process.standardError = pipe
//        process.environment = environment
        process.launchPath = "/bin/zsh"
        process.arguments = ["-c", command]
        if #available(macOS 13.0, *) {
            try! process.run()
        } else {
            process.launch()
        }
        let data = pipe.fileHandleForEading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8) ?? ""
        return output
    }
    
    try app.register(collection: TodoController())
}
