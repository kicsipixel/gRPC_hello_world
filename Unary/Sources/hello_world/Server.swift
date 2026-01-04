import ArgumentParser
import Foundation
import GRPCCore
import GRPCNIOTransportHTTP2
import GRPCProtobuf

struct Server: AsyncParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Starts the server.")

    func run() async throws {
        let server = GRPCServer(
            transport: .http2NIOPosix(
                address: .ipv4(host: "127.0.0.1", port: 31415),
                transportSecurity: .plaintext
            ),
            services: [HelloServiceHandler()]
        )

        try await withThrowingDiscardingTaskGroup { group in
            group.addTask { try await server.serve() }
            if let address = try await server.listeningAddress {
                print("Server is listening on \(address)")
            }
        }
    }
}

struct HelloServiceHandler: Hello_HelloService.SimpleServiceProtocol {
    func sayHello(request: Hello_HelloRequest, context: ServerContext) async throws -> Hello_HelloReply {
        var reply = Hello_HelloReply()
        let recipient = request.name.isEmpty ? "stranger" : request.name
        reply.message = "Hello, \(recipient)!"
        return reply
    }

    func today(request: Hello_TodayRequest, context: ServerContext) async throws -> Hello_TodayReply {
        var reply = Hello_TodayReply()
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        reply.message = "Today is \(formatter.string(from: date))."
        return reply
    }
}
