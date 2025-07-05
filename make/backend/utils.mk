# utils.mk - Utility targets for Go backend projects

.PHONY: check-go-version
check-go-version:
	@current=$$(go version | awk '{print $$3}' | sed 's/go//'); \
	required=$(MIN_GO_VERSION); \
	lowest=$$(printf '%s\n' "$$required" "$$current" | sort -V | head -n1); \
	if [ "$$lowest" != "$$required" ]; then \
		echo "Go version too old: $$current < $$required"; exit 1; \
	fi
