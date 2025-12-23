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
	@rm -rf proto/aptos
	@curl -sL "https://api.github.com/repos/aptos-labs/aptos-core/git/trees/main?recursive=1" \
		| jq -r '.tree[] | select(.path | startswith("protos/proto/aptos")) | select(.path | endswith(".proto")) | .path' \
		| while read -r file; do \
			dest="proto/$${file#protos/proto/}"; \
			mkdir -p "$$(dirname "$$dest")"; \
			curl -sL "https://raw.githubusercontent.com/aptos-labs/aptos-core/main/$$file" -o "$$dest"; \
			echo "  $$dest"; \
		done
	@echo "Proto files updated. Run 'make generate' to regenerate Go bindings."
