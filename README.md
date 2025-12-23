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

```go
package main

import (
    "context"
    "log"

    indexerv1 "github.com/0xbe1/aptos-proto-go/aptos/indexer/v1"
    "google.golang.org/grpc"
    "google.golang.org/grpc/credentials/insecure"
)

func main() {
    // Connect to Aptos indexer gRPC
    conn, err := grpc.NewClient(
        "grpc.mainnet.aptoslabs.com:443",
        grpc.WithTransportCredentials(insecure.NewCredentials()),
    )
    if err != nil {
        log.Fatalf("failed to connect: %v", err)
    }
    defer conn.Close()

    // Create client
    client := indexerv1.NewRawDataClient(conn)

    // Stream transactions
    stream, err := client.GetTransactions(context.Background(), &indexerv1.GetTransactionsRequest{
        StartingVersion: ptr(uint64(0)),
        BatchSize:       ptr(uint64(10)),
    })
    if err != nil {
        log.Fatalf("failed to get transactions: %v", err)
    }

    for {
        resp, err := stream.Recv()
        if err != nil {
            break
        }
        log.Printf("Received %d transactions", len(resp.Transactions))
    }
}

func ptr[T any](v T) *T {
    return &v
}
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
