# aptos-proto-go

Go bindings for [Aptos](https://aptoslabs.com/) Protocol Buffer definitions.

This library provides Go packages generated from the official Aptos proto files, enabling Go applications to interact with Aptos gRPC services.

## Installation

```bash
go get github.com/0xbe1/aptos-proto-go
```

## Packages

| Package | Description |
|---------|-------------|
| `github.com/0xbe1/aptos-proto-go/aptos/transaction/v1` | Transaction types and structures |
| `github.com/0xbe1/aptos-proto-go/aptos/indexer/v1` | Indexer service and streaming APIs |
| `github.com/0xbe1/aptos-proto-go/aptos/internal/fullnode/v1` | Fullnode data streaming |
| `github.com/0xbe1/aptos-proto-go/aptos/remote_executor/v1` | Remote executor network messages |
| `github.com/0xbe1/aptos-proto-go/aptos/util/timestamp` | Timestamp utility types |

## Usage Example

See [examples/basic/main.go](examples/basic/main.go) for a complete example.

Run it with:

```bash
# Get your API key from https://build.aptoslabs.com/
export APTOS_API_KEY="your-api-key"
go run examples/basic/main.go
```

## Regenerating Proto Bindings

To regenerate the Go bindings from the proto files:

```bash
# Install buf if not already installed
brew install bufbuild/buf/buf

# Generate Go bindings
buf generate
```

## Source

Proto definitions are from [aptos-labs/aptos-core](https://github.com/aptos-labs/aptos-core/tree/main/protos/proto).

## License

The proto definitions are licensed under the [Innovation-Enabling Source Code License](https://github.com/aptos-labs/aptos-core/blob/main/LICENSE) by Aptos Foundation.
