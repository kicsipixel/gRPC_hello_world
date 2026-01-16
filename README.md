# gRPC Swift Examples

A collection of Swift gRPC examples demonstrating all four communication patterns using `grpc-swift-2`, SwiftNIO HTTP/2 transport, and Swift Concurrency.


## Projects

### Unary

Classic request-response RPC pattern. Client sends a single request and receives a single response.

**Service Definition:**
```protobuf
service HelloService {
    rpc SayHello(HelloRequest) returns (HelloReply);
    rpc Today(TodayRequest) returns (TodayReply);
}
```

**Usage:**
```bash
cd Unary
swift run hello_world server   # Start server on 127.0.0.1:31415
swift run hello_world client   # Send request
```

### Streaming (Server Streaming)

Server sends a stream of responses to a single client request. Useful for real-time updates or large result sets.

**Service Definition:**
```protobuf
service StreamingService {
    rpc StreamStatus(StatusRequest) returns (stream StatusUpdate);
}
```

Server writes 5 status updates with 1-second intervals using `RPCWriter`.

### ClientStreaming

Client sends a stream of messages; server responds with a single aggregated response. Ideal for file uploads or batch processing.

**Service Definition:**
```protobuf
service UploadService {
    rpc SendChunks(stream Chunk) returns (UploadSummary);
}
```

Server consumes `RPCAsyncSequence<Chunk>` and returns total chunk count and byte size.

### BiDirectionalStreaming

Both client and server exchange streams simultaneously. Suitable for chat applications or real-time data processing.

**Service Definition:**
```protobuf
service UploadService {
    rpc SendChunks(stream Chunk) returns (stream UploadSummary);
}
```

Uses `StreamingServerRequest`/`StreamingServerResponse` for full-duplex communication. Server sends running totals as it receives each chunk.
