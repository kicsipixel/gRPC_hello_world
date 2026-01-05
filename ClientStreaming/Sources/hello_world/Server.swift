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
            services: [UploadServiceHandler()]
        )

        try await withThrowingDiscardingTaskGroup { group in
            group.addTask { try await server.serve() }
            if let address = try await server.listeningAddress {
                print("Server is listening on \(address)")
            }
        }
    }
}

struct UploadServiceHandler: Hello_UploadService.SimpleServiceProtocol {
    func sendChunks(request: GRPCCore.RPCAsyncSequence<Hello_Chunk, any Error>, context: GRPCCore.ServerContext) async throws -> Hello_UploadSummary {
        var count = 0
        var totalBytes: Int64 = 0

        for try await chunk in request {
            count += 1
            totalBytes += Int64(chunk.data.count)
        }
        return .with {
            $0.totalChunks = Int32(count)
            $0.totalBytes = totalBytes
        }
    }
}
