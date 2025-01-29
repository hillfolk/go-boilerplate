BIN_NAME=go-boilerplate
IMAGE_NAME=hillfolk/${BIN_NAME}
GO_VERSION=1.23
VERSION_PACKAGE := github.com/hillfolk/go-boilerplate/version
GO := go
ifdef GO_BIN
	GO = $(GO_BIN)
endif

BIN_PATH := $(GOPATH)/bin
GOLANGCI_LINT := $(BIN_DIR)/golangci-lint

GIT_COMMIT := $(shell git rev-parse --short HEAD 2> /dev/null || echo "no-revision")
GIT_COMMIT_MESSAGE := $(shell git show -s --format='%s' 2> /dev/null | tr ' ' _ | tr -d "'")
GIT_TAG := $(shell git describe --tags 2> /dev/null || echo "no-tag")
GIT_BRANCH := $(shell git rev-parse --abbrev-ref HEAD 2> /dev/null || echo "no-branch")
BUILD_TIME := $(shell date +%FT%T%z)

all: go/test go/lint


deps:
	go mod tidy
	go install github.com/spf13/cobra-cli@v1.3.0
	go install github.com/goreleaser/goreleaser@latest
	go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest

go/lint:
	golangci-lint run ./...

go/tidy:
	$(GO) mod tidy -v

go/fmt:
	gofmt -s -w .

go/build:
	@echo "building ${BIN_NAME}"
	@echo "GOPATH=${GOPATH}"
	go generate ./...
	go build -o ${BIN_PATH}/${BIN_NAME}

# Use this target when building in CI so that you get all the lovely version information in the resulting executable
ci/build:
	$(GO) build -v -ldflags '-X $(VERSION_PACKAGE).GitHash=$(GIT_COMMIT) -X $(VERSION_PACKAGE).GitTag=$(GIT_TAG) -X $(VERSION_PACKAGE).GitBranch=$(GIT_BRANCH) -X $(VERSION_PACKAGE).BuildTime=$(BUILD_TIME) -X $(VERSION_PACKAGE).GitCommitMessage=$(GIT_COMMIT_MESSAGE)' -o ${BIN_PATH}/${BIN_NAME}

go/test: go/build
	$(GO) test -cover -race -v ./...

go/test-coverage:
	$(GO) test ./... -race -coverprofile=.testCoverage.txt && $(GO) tool cover -html=.testCoverage.txt

ci/test: ci/build
	$(GO) test -race $$($(GO) list ./...) -v -coverprofile .testCoverage.txt

goreleaser/test:
	goreleaser --snapshot --skip-publish --rm-dist

## Compile optimized for alpine linux.
docker/build:
	@echo "building image ${IMAGE_NAME}"
	docker build --build-arg GO_VERSION=${GO_VERSION} -t $(IMAGE_NAME):latest .