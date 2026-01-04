import ArgumentParser

@main
struct HelloWorld: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "hello_world",
        abstract: "A multi-tool to run the server and client.",
        subcommands: [Server.self, Client.self]
    )
}
