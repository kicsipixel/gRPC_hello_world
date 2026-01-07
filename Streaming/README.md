# gRPC hello‑world-streaming
A minimal, clean Swift gRPC project containing both a server and a client.
The example demonstrates how to define a .proto service, generate Swift gRPC code, implement the server logic, and call the RPCs from a client executable.

## Project structure
```
.
├── Package.resolved
├── Package.swift
├── proto
│   └── streaming.proto
├── README.md
└── Sources
    └── hello_world
        ├── Client.swift
        ├── Generated
        │   ├── streaming.grpc.swift
        │   └── streaming.pb.swift
        ├── hello_world.swift
        └── Server.swift
```

## Protocol Buffers Definition
The service is defined in proto/hello.proto:

```
edition = "2023";

// Define the package namespace for generated code.
package hello;

service StreamingService {
    // The server sends a stream of StatusUpdate messages back to the client.
    rpc StreamStatus(StatusRequest) returns (stream StatusUpdate);
}

// Empty request message
message StatusRequest {}

// Each streamed update from the server
message StatusUpdate {
    string message = 1;
}
```

## Running the Example
### 1. Start the server

```
$ swift run hello_world server
```

### 2. Run the client
#### Streaming:
```
$ swift run client
```