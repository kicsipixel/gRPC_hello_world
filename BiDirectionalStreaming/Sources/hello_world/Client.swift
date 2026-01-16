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
        ) { connection in

            let client = Hello_UploadService.Client(wrapping: connection)

            try await client.sendChunks(
                requestProducer: { writer in
                    for i in 1...50 {
                        var chunk = Hello_Chunk()
                        chunk.data = Data("chunk-\(i)".utf8)
                        try await writer.write(chunk)
                    }
                    // stream closes automatically when closure returns
                },
                onResponse: { response in
                    // response.messages is the async sequence of streamed UploadSummary
                    for try await summary in response.messages {
                        print("Total chunks: \(summary.totalChunks)")
                        print("Total bytes: \(summary.totalBytes)")
                    }
                }
            )
        }
    }
}
