import ArgumentParser
import GRPCCore
import GRPCNIOTransportHTTP2
import GRPCProtobuf

struct Client: AsyncParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Sends a request to the server")

    @Option(help: "The person to greet")
    var name: String = ""

    @Flag(help: "Ask the server what day it is")
    var today = false

    func run() async throws {
        try await withGRPCClient(
            transport: .http2NIOPosix(
                target: .dns(host: "127.0.0.1", port: 31415),
                transportSecurity: .plaintext
            )
        ) { client in
            let client = Hello_HelloService.Client(wrapping: client)

            if today {
                let reply = try await client.today(.init())
                print(reply.message)
            } else {
                let reply = try await client.sayHello(.with { $0.name = self.name })
                print(reply.message)
            }
        }
    }
}
