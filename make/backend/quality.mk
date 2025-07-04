# quality.mk - Quality control targets

SECTION_MAPS += quality:Quality

## quality/tidy: Tidy modfiles and format .go files
.PHONY: tidy
tidy:
	go fmt ./...
	go mod tidy
	go mod verify
	goimports -w .
	golines -m 120 -w --ignore-generated .
	gci write --skip-generated -s standard -s "prefix($(MODULE))" -s default -s blank -s dot --custom-order  .
	gofumpt -l -w .

## quality/lint: Run linters
.PHONY: lint
lint:
	revive -config revive-config.toml -formatter friendly ./...
	golangci-lint run ./...

## quality/audit: Run quality control checks
.PHONY: audit
audit:
	go mod verify
	go vet ./...
	staticcheck -checks=all,-ST1000,-U1000 ./...
	govulncheck ./...
	go test -race ./...

## quality/vet: Run go vet
.PHONY: vet
vet:
	go vet ./...
