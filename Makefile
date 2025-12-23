.PHONY: generate clean update-protos

# Generate Go bindings from proto files
generate:
	buf generate

# Clean generated files
clean:
	find . -name "*.pb.go" -delete

# Update proto files from aptos-core and regenerate
update-protos:
	@echo "Updating proto files from aptos-core..."
	@mkdir -p proto/aptos/indexer/v1 proto/aptos/transaction/v1 proto/aptos/internal/fullnode/v1 proto/aptos/remote_executor/v1 proto/aptos/util/timestamp
	@curl -sL https://raw.githubusercontent.com/aptos-labs/aptos-core/main/protos/proto/aptos/indexer/v1/raw_data.proto -o proto/aptos/indexer/v1/raw_data.proto
	@curl -sL https://raw.githubusercontent.com/aptos-labs/aptos-core/main/protos/proto/aptos/indexer/v1/grpc.proto -o proto/aptos/indexer/v1/grpc.proto
	@curl -sL https://raw.githubusercontent.com/aptos-labs/aptos-core/main/protos/proto/aptos/indexer/v1/filter.proto -o proto/aptos/indexer/v1/filter.proto
	@curl -sL https://raw.githubusercontent.com/aptos-labs/aptos-core/main/protos/proto/aptos/transaction/v1/transaction.proto -o proto/aptos/transaction/v1/transaction.proto
	@curl -sL https://raw.githubusercontent.com/aptos-labs/aptos-core/main/protos/proto/aptos/internal/fullnode/v1/fullnode_data.proto -o proto/aptos/internal/fullnode/v1/fullnode_data.proto
	@curl -sL https://raw.githubusercontent.com/aptos-labs/aptos-core/main/protos/proto/aptos/remote_executor/v1/network_msg.proto -o proto/aptos/remote_executor/v1/network_msg.proto
	@curl -sL https://raw.githubusercontent.com/aptos-labs/aptos-core/main/protos/proto/aptos/util/timestamp/timestamp.proto -o proto/aptos/util/timestamp/timestamp.proto
	@echo "Proto files updated. Run 'make generate' to regenerate Go bindings."
