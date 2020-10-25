# Directories
ROOT_DIR        ?= $(realpath $(dir $(lastword $(MAKEFILE_LIST))))/../../ # In case of ROOT_DIR not defined main make file
BUILD_DIR       := $(ROOT_DIR)/build

# Commands
GOBUILD         := go build
GOMOD           := go mod
GOCLEAN         := go clean

# Variables
MODULE          := $(shell go list -m)
VERSION         := $(strip $(shell [ -d .git ] && git describe --always --tags --dirty))
VCS_REF         := $(strip $(shell [ -d .git ] && git rev-parse HEAD))
BUILD_TIMESTAMP := $(shell date -u +"%Y-%m-%dT%H:%M:%S%Z")
BUILD_LDFLAGS   := '-s -w -X "$(MODULE)/version.Version=$(VERSION)" -X "$(MODULE)/version.Commit=$(VCS_REF)" -X "$(MODULE)/version.Date=$(BUILD_TIMESTAMP)"'

.PHONY: clean
clean: ## Cleanup everything
clean: ; $(info $(M) cleaning )
	$(Q) $(GOCLEAN)
	$(Q) $(shell rm -rf $(GOBIN) $(BUILD_DIR))

.PHONY: vendor
vendor: ## Updates vendored copy of dependencies
vendor: ; $(info $(M) running go mod vendor)
	$(Q) $(GOMOD) tidy
	$(Q) $(GOMOD) vendor

.PHONY: build
build: ## Builds binary
build: vendor $(ROOT_DIR)/main.go $(wildcard *.go) $(wildcard */*.go) $(BUILD_DIR) ; $(info $(M) building binary)
	$(Q) CGO_ENABLED=0 $(GOBUILD) -a -tags netgo -ldflags $(BUILD_LDFLAGS) -o $(BUILD_DIR)/hello-world .

.PHONY: version
version: ## Shows application version
	$(Q) echo $(VERSION)

$(BUILD_DIR): ; $(info $(M) creating build directory)
	$(Q) $(shell mkdir -p $@)