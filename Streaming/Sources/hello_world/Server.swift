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
            services: [StreamingServiceHandler()]
        )

        try await withThrowingDiscardingTaskGroup { group in
            group.addTask { try await server.serve() }
            if let address = try await server.listeningAddress {
                print("Server is listening on \(address)")
            }
        }
    }
}

struct StreamingServiceHandler: Hello_StreamingService.SimpleServiceProtocol {
    func streamStatus(request: Hello_StatusRequest, response: RPCWriter<Hello_StatusUpdate>, context: ServerContext) async throws {
        for i in 1...5 {
            var update = Hello_StatusUpdate()
            update.message = "Update #\(i)"
            try await response.write(update)
            try await Task.sleep(nanoseconds: 1_000_000_000)
        }
    }
}
