# Project directories
ROOT_DIR        := $(CURDIR)
BUILD_DIR       := $(ROOT_DIR)/build

# External targets
include .bingo/Variables.mk
include scripts/make/help.mk
include scripts/make/lint.mk

# Commands used in Makefile
GOCMD           := go
GOBUILD         := $(GOCMD) build
GOTEST          := $(GOCMD) test
GOMOD           := $(GOCMD) mod
GOINSTALL       := $(GOCMD) install
GOCLEAN         := $(GOCMD) clean



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