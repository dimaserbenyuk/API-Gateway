APP_NAME := bootstrap
BUILD_DIR := bin
ZIP_FILE := $(BUILD_DIR)/handler.zip
BINARY_FILE := $(APP_NAME)
SRC := handler.go

# Цвета для вывода
GREEN := \033[0;32m
NC := \033[0m

# Сборка для AWS Lambda (runtime: provided.al2, бинарник должен называться bootstrap)
build:
	@echo "$(GREEN)> Building for AWS Lambda (linux/amd64, runtime: provided.al2)$(NC)"
	GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o $(APP_NAME) $(SRC)
	mkdir -p $(BUILD_DIR)
	zip -j $(ZIP_FILE) $(APP_NAME)
	@echo "$(GREEN)> Build complete: $(ZIP_FILE)$(NC)"

# Локальная сборка для Mac (для отладки вне Lambda)
build-local:
	@echo "$(GREEN)> Building for local testing (darwin/arm64)$(NC)"
	GOOS=darwin GOARCH=arm64 go build -o $(BUILD_DIR)/$(APP_NAME)_local $(SRC)

# Очистка временных файлов
clean:
	@echo "$(GREEN)> Cleaning build artifacts$(NC)"
	rm -rf $(BUILD_DIR)/*
	rm -f $(APP_NAME)

# Unit тесты
test:
	@echo "$(GREEN)> Running unit tests$(NC)"
	go test -v ./...

# Статический анализ
lint:
	@echo "$(GREEN)> Running lint check (requires golangci-lint)$(NC)"
	golangci-lint run

# Проверка безопасности
security:
	@echo "$(GREEN)> Checking for security issues (requires gosec)$(NC)"
	gosec ./...

# Деплой через Serverless Framework
deploy:
	@echo "$(GREEN)> Deploying with Serverless Framework$(NC)"
	sls deploy --stage dev

# Просмотр логов Lambda
logs:
	sls logs -f getTodo --stage dev

# Хелп
help:
	@echo ""
	@echo "$(GREEN)Makefile commands:$(NC)"
	@echo "  make build         - Сборка и упаковка для AWS Lambda (runtime: provided.al2)"
	@echo "  make build-local   - Локальная сборка под Mac (для тестов)"
	@echo "  make clean         - Удалить артефакты сборки"
	@echo "  make test          - Запустить юнит-тесты"
	@echo "  make lint          - Статический анализ (golangci-lint)"
	@echo "  make security      - Проверка безопасности (gosec)"
	@echo "  make deploy        - Деплой через Serverless Framework"
	@echo "  make logs          - Просмотр логов Lambda"
