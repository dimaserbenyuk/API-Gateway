APP_NAME := bootstrap
BUILD_DIR := bin
ZIP_FILE := $(BUILD_DIR)/handler.zip
BINARY_FILE := $(APP_NAME)
SRC := cmd/main.go

# Terminal colors
GREEN := \033[0;32m
NC := \033[0m

# Build for AWS Lambda (runtime: provided.al2, binary must be named 'bootstrap')
build:
	@echo "$(GREEN)> Building for AWS Lambda (linux/amd64, runtime: provided.al2)$(NC)"
	GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o $(APP_NAME) $(SRC)
	mkdir -p $(BUILD_DIR)
	zip -j $(ZIP_FILE) $(APP_NAME)
	@echo "$(GREEN)> Build complete: $(ZIP_FILE)$(NC)"

# Local build for Mac (for local testing)
build-local:
	@echo "$(GREEN)> Building for local testing (darwin/arm64)$(NC)"
	GOOS=darwin GOARCH=arm64 go build -o $(BUILD_DIR)/$(APP_NAME)_local $(SRC)

# Clean temporary build artifacts
clean:
	@echo "$(GREEN)> Cleaning build artifacts$(NC)"
	rm -rf $(BUILD_DIR)/*
	rm -f $(APP_NAME)

# Run unit tests
test:
	@echo "$(GREEN)> Running unit tests$(NC)"
	go test -v ./...

# Run static analysis
lint:
	@echo "$(GREEN)> Running lint check (requires golangci-lint)$(NC)"
	golangci-lint run

# Run security analysis
security:
	@echo "$(GREEN)> Checking for security issues (requires gosec)$(NC)"
	gosec ./...

# Deploy using Serverless Framework
deploy:
	@echo "$(GREEN)> Deploying with Serverless Framework$(NC)"
	sls deploy --stage dev

# Show logs from the Lambda function
logs:
	sls logs -f getTodo --stage dev

# Help command - shows available make commands
help:
	@echo ""
	@echo "$(GREEN)Makefile commands:$(NC)"
	@echo "  make build         - Build and package for AWS Lambda (runtime: provided.al2)"
	@echo "  make build-local   - Local build for Mac (for testing)"
	@echo "  make clean         - Remove build artifacts"
	@echo "  make test          - Run unit tests"
	@echo "  make lint          - Run static analysis (golangci-lint)"
	@echo "  make security      - Run security checks (gosec)"
	@echo "  make deploy        - Deploy using Serverless Framework"
	@echo "  make logs          - View Lambda logs"
