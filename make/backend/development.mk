# development.mk - Development targets

SECTION_MAPS += dev:Development

## dev/generate: Run go generate for all packages
.PHONY: generate
generate:
	go generate ./...

## dev/generate-mock: Generate mocks with mockery
.PHONY: generate-mock
generate-mock:
	mockery --all --output=$(MOCKS)

## dev/doc: Generate documentation [PKG=pattern] (e.g., make doc PKG=core)
.PHONY: doc
doc:
	@theme=$(if $(CHROMA_THEME),$(CHROMA_THEME),rrt); \
	packages=$$(go list ./...); \
	pattern="$(PKG)"; \
	if [ -n "$$pattern" ]; then \
		packages=$$(echo "$$packages" | grep "$$pattern"); \
		if [ -z "$$packages" ]; then \
			echo "No packages found for pattern: $$pattern"; \
			exit 1; \
		fi; \
	fi; \
	count=$$(echo "$$packages" | wc -l | tr -d ' '); \
	echo "Generating documentation for $$count package(s):"; \
	for pkg in $$packages; do \
		echo "===== Package: $$pkg ====="; \
		go doc $$pkg | chroma -l go -s $$theme; \
		echo; \
	done

## dev/doc-serve: Serve documentation locally for browsing
.PHONY: doc-serve
doc-serve:
	pkgsite -http=localhost:6060
