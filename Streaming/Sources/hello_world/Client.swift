import ArgumentParser
import GRPCCore
import GRPCNIOTransportHTTP2
import GRPCProtobuf

struct Client: AsyncParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Sends a request to the server")

    func run() async throws {
        try await withGRPCClient(
            transport: .http2NIOPosix(
                target: .dns(host: "127.0.0.1", port: 31415),
                transportSecurity: .plaintext
            )
        ) { client in
            let client = Hello_StreamingService.Client(wrapping: client)

            try await client.streamStatus(
                request: .init(message: Hello_StatusRequest()),
                onResponse: { response in
                    for try await update in response.messages {
                        print(update.message)
                    }
                }
            )
            return
        }
    }
}
