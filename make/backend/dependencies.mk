# dependencies.mk - Dependency management

SECTION_MAPS += deps:Dependencies

## deps/deps-reset: Reset go.mod changes
.PHONY: deps-reset
deps-reset:
	git checkout -- go.mod go.sum
	go mod tidy

## deps/deps-upgrade: Upgrade all dependencies
.PHONY: deps-upgrade
deps-upgrade:
	go get -u -t -v ./...
	go mod tidy
	go mod download

## deps/deps-cleancache: Clean Go modules cache
.PHONY: deps-cleancache
deps-cleancache:
	go clean -modcache

## deps/deps-tidy: Clean up go.mod and go.sum
.PHONY: deps-tidy
deps-tidy:
	go mod tidy
	go mod verify

## deps/deps-outdated: List outdated dependencies
.PHONY: deps-outdated
deps-outdated:
	@go list -u -f '{{if (and (not (or .Main .Indirect)) .Update)}}{{.Path}}: {{.Version}} -> {{.Update.Version}}{{end}}' -m all

## deps/modgraph: Print module dependency graph
.PHONY: modgraph
modgraph:
	go mod graph | sort

## deps/tools: Install development tools
.PHONY: tools
tools:
	@echo "Installing core development tools..."
	@for tool in $(CORE_TOOLS); do \
		echo "Installing $$tool..."; \
		go install $$tool; \
	done

	@if [ -n "$(EXTRA_TOOLS)" ]; then \
		echo "Installing extra tools: $(EXTRA_TOOLS)"; \
		for tool in $(EXTRA_TOOLS); do \
			echo "Installing $$tool..."; \
			go install $$tool; \
		done; \
	fi

	@echo "All tools installed successfully!"
