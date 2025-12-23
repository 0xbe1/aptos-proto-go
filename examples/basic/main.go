package main

import (
	"context"
	"encoding/hex"
	"io"
	"log"
	"os"

	indexerv1 "github.com/0xbe1/aptos-proto-go/aptos/indexer/v1"
	transactionv1 "github.com/0xbe1/aptos-proto-go/aptos/transaction/v1"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials"
	"google.golang.org/grpc/metadata"
)

func main() {
	// Get API key from environment variable
	// Get your API key from https://build.aptoslabs.com/
	apiKey := os.Getenv("APTOS_API_KEY")
	if apiKey == "" {
		log.Fatal("APTOS_API_KEY environment variable is required. Get one at https://build.aptoslabs.com/")
	}

	// Connect to Aptos indexer gRPC
	conn, err := grpc.NewClient(
		"grpc.mainnet.aptoslabs.com:443",
		grpc.WithTransportCredentials(credentials.NewClientTLSFromCert(nil, "")),
		grpc.WithDefaultCallOptions(grpc.MaxCallRecvMsgSize(100*1024*1024)), // 100MB max
	)
	if err != nil {
		log.Fatalf("failed to connect: %v", err)
	}
	defer conn.Close()

	// Create client
	client := indexerv1.NewRawDataClient(conn)

	// Add API key to request metadata
	ctx := metadata.AppendToOutgoingContext(context.Background(),
		"authorization", "Bearer "+apiKey,
	)

	// Stream latest transactions (omitting StartingVersion starts from latest)
	log.Println("Streaming latest transactions...")
	stream, err := client.GetTransactions(ctx, &indexerv1.GetTransactionsRequest{
		TransactionsCount: ptr(uint64(10)), // Fetch 10 transactions then stop
	})
	if err != nil {
		log.Fatalf("failed to get transactions: %v", err)
	}

	for {
		resp, err := stream.Recv()
		if err == io.EOF {
			log.Println("Stream ended")
			break
		}
		if err != nil {
			log.Fatalf("error receiving: %v", err)
		}

		for _, txn := range resp.Transactions {
			printTransaction(txn)
		}
	}
}

func printTransaction(txn *transactionv1.Transaction) {
	txType := txn.Type.String()
	version := txn.Version
	success := txn.Info.Success
	gasUsed := txn.Info.GasUsed
	hash := hex.EncodeToString(txn.Info.Hash)

	// For user transactions, show sender
	if userTxn := txn.GetUser(); userTxn != nil {
		sender := userTxn.Request.Sender
		log.Printf("v%d | %s | sender=%s | gas=%d | success=%t | hash=%s",
			version, txType, sender, gasUsed, success, hash[:16]+"...")
	} else {
		log.Printf("v%d | %s | gas=%d | success=%t | hash=%s",
			version, txType, gasUsed, success, hash[:16]+"...")
	}
}

func ptr[T any](v T) *T {
	return &v
}
