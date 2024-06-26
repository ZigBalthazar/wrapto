PACKAGES=$(shell go list ./... | grep -v 'tests' | grep -v 'grpc/gen')

ifneq (,$(filter $(OS),Windows_NT MINGW64))
EXE = .exe
RM = del /q
else
RM = rm -rf
endif

### Tools needed for development
devtools:
	@echo "Installing devtools"
	go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
	go install mvdan.cc/gofumpt@latest
	go install github.com/ethereum/go-ethereum/cmd/abigen@latest

### Building

build:
	go build -o build/wrapto$(EXE)  .

### ABIs (EVM contracts)
build-abis:
	abigen --abi ./abis/WrappedPac.json --pkg polygon --type WrappedPac --out ./sides/polygon/wrapped_pac.go

### proto
proto:
	$(RM) -rf client/pactus/gen/go
	cd sides/pactus/buf && buf generate --template buf.gen.yaml ../proto

### Testing
unit_test:
	go test $(PACKAGES)

test:
	go test ./... -covermode=atomic

test_race:
	go test ./... --race

### Docker

# TODO

### Formatting the code
fmt:
	gofumpt -l -w .
	go mod tidy

check:
	golangci-lint run --timeout=20m0s


### pre commit
pre-commit: fmt check unit_test
	@echo ready to commit...

.PHONY: build
