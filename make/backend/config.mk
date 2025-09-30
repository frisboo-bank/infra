# config.mk - Global configuration and variables

# Make sure Make uses strict variable checking and disables built-in rules
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

.DEFAULT_GOAL := help
.EXPORT_ALL_VARIABLES:

# Go build environment (can be overridden with `make VAR=value`)
GOFLAGS ?=
export CGO_ENABLED ?= 0
export GO111MODULE ?= on
export GOARCH ?= $(shell go env GOARCH)
export GOOS ?= $(shell go env GOOS)

# Minimum Go version (see utils.mk)
MIN_GO_VERSION ?= 1.20

# Project metadata
MODULE ?= $(shell go list -m)
NAME   ?= $(notdir $(MODULE))

# Binary and artifact locations
DIST_DIR ?= dist
MOCKS_DIR ?= mocks
COVERAGE ?= coverage.out

# Docker and CI
DOCKER_HUB_USER ?= frisboo-bank
IMAGES ?=

# Theme used for syntax highlighting (chroma --list to have the available list)
CHROMA_THEME ?= rrt

# Core tools
CORE_TOOLS := \
	github.com/alecthomas/chroma/v2@latest \
	github.com/daixiang0/gci@latest \
	github.com/golangci/golangci-lint/cmd/golangci-lint@latest \
	github.com/kyoh86/richgo@latest \
	github.com/mgechev/revive@latest \
	github.com/segmentio/golines@latest \
	github.com/vektra/mockery/v2@latest \
	github.com/zarldev/goenums@latest \
	golang.org/x/pkgsite/cmd/pkgsite@latest \
	golang.org/x/tools/cmd/goimports@latest \
	golang.org/x/vuln/cmd/govulncheck@latest \
	honnef.co/go/tools/cmd/staticcheck@latest \
	mvdan.cc/gofumpt@latest

# Consumer-extendable tool list
EXTRA_TOOLS ?=
