import ArgumentParser
import Foundation
import GRPCCore
import GRPCNIOTransportHTTP2
import GRPCProtobuf

struct Client: AsyncParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Sends streamed chunks to the server")

    func run() async throws {
        try await withGRPCClient(
            transport: .http2NIOPosix(
                target: .dns(host: "127.0.0.1", port: 31415),
                transportSecurity: .plaintext
            )
        ) { client in
            let client = Hello_UploadService.Client(wrapping: client)

            try await client.sendChunks { writer in
                for i in 1...50 {
                    var chunk = Hello_Chunk()
                    chunk.data = Data("chunk-\(i)".utf8)
                    try await writer.write(chunk)
                }
            } onResponse: { response in
                let summary = try response.message
                print("Total chunks: \(summary.totalChunks)")
                print("Total bytes: \(summary.totalBytes)")
            }
            return
        }
    }
}
