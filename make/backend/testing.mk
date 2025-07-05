# testing.mk - Test and coverage targets

SECTION_MAPS += test:Testing

## test/test: Run all tests
.PHONY: test
test:
	go test -v ./...

## test/quick-test: Run only quick Go tests
.PHONY: quick-test
quick-test:
	go test -short ./...

## test/coverage: Run tests with code coverage
.PHONY: coverage
coverage:
	go test -coverprofile=$(COVERAGE) ./...
	go tool cover -func=$(COVERAGE)

## test/coverage-html: Open HTML coverage report in browser
.PHONY: coverage-html
coverage-html:
	go tool cover -html=$(COVERAGE)

## test/bench: Run Go benchmarks
.PHONY: bench
bench:
	go test -bench=. -benchmem ./...

## test/benchcmp: Compare two benchmark outputs
.PHONY: benchcmp
benchcmp:
	benchcmp old.txt new.txt

## test/debug: Run tests with Delve debugger
.PHONY: debug
debug:
	dlv test ./...
