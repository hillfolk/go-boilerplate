# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Go CLI application boilerplate using the Cobra framework. It provides a foundation for building command-line tools with proper logging, version management, and Docker support.

**Key Dependencies:**
- `github.com/spf13/cobra` - CLI framework for command structure
- `go.uber.org/zap` - High-performance structured logging library
- `github.com/common-nighthawk/go-figure` - ASCII art splash screen

## Build and Development Commands

### Standard Development Workflow

```bash
# Install development dependencies (cobra-cli, goreleaser, golangci-lint)
make deps

# Run tests with race detection and coverage
make go/test

# Run linter
make go/lint

# Format code
make go/fmt

# Build binary (outputs to $GOPATH/bin/go-boilerplate)
make go/build

# Run all checks (test + lint)
make all
```

### CI/Production Builds

```bash
# Build with version information injected via ldflags
make ci/build

# Run tests with coverage report in CI
make ci/test

# Test goreleaser configuration without publishing
make goreleaser/test
```

### Docker

```bash
# Build optimized Docker image for Alpine Linux
make docker/build
```

### Test Coverage

```bash
# Generate and open HTML coverage report
make go/test-coverage
```

## Architecture and Structure

### Version Injection System

The project uses a build-time version injection mechanism:

1. **Version variables** (`version/version.go`): Declares variables `GitHash`, `GitBranch`, `GitTag`, `GitCommitMessage`, and `BuildTime` with default values of `"-"`

2. **Makefile extracts git metadata** using shell commands:
   - `GIT_COMMIT`: Short commit hash
   - `GIT_TAG`: Most recent git tag
   - `GIT_BRANCH`: Current branch name
   - `GIT_COMMIT_MESSAGE`: Latest commit message (spaces replaced with underscores)
   - `BUILD_TIME`: ISO 8601 timestamp

3. **CI build target** (`make ci/build`) injects these values via `-ldflags '-X $(VERSION_PACKAGE).GitHash=$(GIT_COMMIT) ...'`

4. **Runtime restoration**: `version.init()` converts underscores back to spaces in commit messages

This allows binaries to embed complete version metadata without runtime git dependencies.

### Project Layout

```
cmd/        - Cobra command definitions (root command in root.go)
log/        - Logging setup and configuration (zap wrapper)
pkg/        - Reusable packages (currently empty, for future libraries)
type/       - Constants and type definitions (currently empty)
version/    - Version information and build metadata
main.go     - Entry point: sets up logging, displays splash, executes root command
```

### Logging Architecture

The `log` package wraps `zap` with two output modes:
- **Console mode** (default): Human-readable colored output via `zap.NewDevelopmentConfig()`
- **JSON mode**: Structured JSON logs for production via `zap.NewProductionConfig()`

Configuration is centralized in `log.Setup(useJSON bool)` called from `main.go`. The package provides:
- `Logger()` - Returns typed `*zap.Logger` for structured logging
- `Sugar()` - Returns `*zap.SugaredLogger` for printf-style logging
- `Sync()` - Flushes buffered logs (called via defer in main.go)

### CLI Command Structure

Built on Cobra framework with entry points:
- `main.go` → calls `cmd.Execute()`
- `cmd/root.go` → defines root command and bootstraps subcommands

To add new commands, create files in `cmd/` and register them in `init()` functions.

## Customization for New Projects

When forking this boilerplate, update:

1. **Service name** in `version/version.go`:
   ```go
   const ServiceName = "your-app-name"
   ```

2. **Makefile variables**:
   ```makefile
   BIN_NAME=your-app-name
   IMAGE_NAME=your-org/${BIN_NAME}
   VERSION_PACKAGE := github.com/your-org/your-app-name/version
   ```

3. **Module path** in `go.mod`:
   ```go
   module github.com/your-org/your-app-name
   ```

4. **Docker paths** in `Dockerfile` (WORKDIR, COPY paths, binary name)

5. **Import paths** throughout the codebase to match new module name

## Testing Conventions

- All tests use the standard `testing` package
- Race detection is enabled by default in `make go/test`
- Coverage reports generated via `go test -coverprofile`
- Tests should be colocated with source files (`*_test.go`)
