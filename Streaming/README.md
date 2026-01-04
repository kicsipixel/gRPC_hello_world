# gRPC hello‑world-streaming
A minimal, clean Swift gRPC project containing both a server and a client.
The example demonstrates how to define a .proto service, generate Swift gRPC code, implement the server logic, and call the RPCs from a client executable.

## Project structure
```
.
├── hello_world.paw
├── Package.resolved
├── Package.swift
├── proto
│   └── hello.proto
├── README.md
└── Sources
    └── hello_world
        ├── Client.swift
        ├── Generated
        │   ├── hello.grpc.swift
        │   └── hello.pb.swift
        ├── hello_world.swift
        └── Server.swift
```

## Protocol Buffers Definition
The service is defined in proto/hello.proto:

```
edition = "2023";

// Define the package namespace for generated code.
package hello;

service HelloService {
    // SayHello takes a HelloRequest and returns a HelloReply.
    rpc SayHello(HelloRequest) returns (HelloReply);
    // Today takes a TodayRequest and returns a TodayReply.
    rpc Today(TodayRequest) returns (TodayReply);
    // The server sends a stream of StatusUpdate messages back to the client.
    rpc StreamStatus(StatusRequest) returns (stream StatusUpdate);
}

// HelloRequest represents the input message sent by the client.
message HelloRequest {
    string name = 1; // The name to include in the greeting.
}

// HelloReply represents the response message returned by the server.
message HelloReply {
    string message = 1; // The greeting text returned to the client.
}

// TodayRequest is empty request
message TodayRequest {}

// TodayReply represents the response message returned by the server.
message TodayReply {
    string message = 1; // The name of the day.
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
#### Hello:
```
$ swift run client --name World
```
#### Ask for today:
```
$ swift run client --today
```
#### Streaming:
```
$ swift run client --stream
```