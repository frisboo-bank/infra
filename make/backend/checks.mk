# checks.mk - Verification and CI check targets

SECTION_MAPS += checks:Checks

## checks/check: Run all checks and tests
.PHONY: check
check: check-go-version tidy lint audit test coverage

## checks/ci: Run CI checks
.PHONY: ci
ci: check

## checks/precommit: Run pre-commit checks
.PHONY: precommit
precommit: check
