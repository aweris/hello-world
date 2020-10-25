# External targets
include .bingo/Variables.mk
include scripts/make/help.mk

# Project directories
ROOT_DIR        := $(CURDIR)
BUILD_DIR       := $(ROOT_DIR)/build

# All go files belong to project
GOFILES          = $(shell find . -type f -name '*.go' -not -path './vendor/*')

# Commands used in Makefile
GOCMD           := go
GOBUILD         := $(GOCMD) build
GOTEST          := $(GOCMD) test
GOMOD           := $(GOCMD) mod
GOINSTALL       := $(GOCMD) install
GOCLEAN         := $(GOCMD) clean
GOFMT           := gofmt


MODULE          := $(shell $(GOCMD) list -m)
VERSION         := $(strip $(shell [ -d .git ] && git describe --always --tags --dirty))

# Build variables
BUILD_TIMESTAMP := $(shell date -u +"%Y-%m-%dT%H:%M:%S%Z")
BUILD_LDFLAGS   := '-s -w -X "$(MODULE)/version.Version=$(VERSION)" -X "$(MODULE)/version.BuildDate=$(BUILD_TIMESTAMP)"'

# Helper variables
V = 0
Q = $(if $(filter 1,$V),,@)
M = $(shell printf "\033[34;1m▶\033[0m")

.PHONY: hello-world
hello-world: ## Builds hello-world binary
hello-world: vendor main.go $(wildcard *.go) $(wildcard */*.go) $(BUILD_DIR) ; $(info $(M) building binary)
	$(Q) CGO_ENABLED=0 $(GOBUILD) -a -tags netgo -ldflags $(BUILD_LDFLAGS) -o $(BUILD_DIR)/$@ .

.PHONY: vendor
vendor: ## Updates vendored copy of dependencies
vendor: ; $(info $(M) running go mod vendor)
	$(Q) $(GOMOD) tidy
	$(Q) $(GOMOD) vendor

.PHONY: fix
fix: ## Fix found issues (if it's supported by the $(GOLANGCI_LINT))
fix: ; $(info $(M) runing golangci-lint run --fix)
	$(Q) $(GOLANGCI_LINT) run --fix --enable-all -c .golangci.yml

.PHONY: fmt
fmt: ## Runs gofmt
fmt: ; $(info $(M) runnig gofmt )
	$(Q) $(GOFMT) -d -s $(GOFILES)

.PHONY: lint
lint: ## Runs golangci-lint analysis
lint: vendor fmt ; $(info $(M) runnig golangci-lint analysis)
	$(Q) $(GOLANGCI_LINT) run

.PHONY: clean
clean: ## Cleanup everything
clean: ; $(info $(M) cleaning )
	$(Q) $(GOCLEAN)
	$(Q) $(shell rm -rf $(GOBIN) $(BUILD_DIR))

.PHONY: test
test: ## Runs go test
test: ; $(info $(M) runnig tests)
	$(Q) $(GOTEST) -race -cover -v ./...

.PHONY: version
version: ## Shows application version
	$(Q) echo $(VERSION)

$(BUILD_DIR): ; $(info $(M) creating build directory)
	$(Q) $(shell mkdir -p $@)