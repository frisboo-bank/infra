#
# MISC
#

SECTION_MAPS += misc:Miscellaneous

## misc/clean: Clean build/test artifacts
.PHONY: clean
clean:
	rm -f $(COVERAGE)
	rm **/*_enums.go
	rm -rf ./mocks

## misc/version: Print project version
.PHONY: version
version:
	@echo "Library:     $(MODULE)"
	@echo "Version:     $$(git describe --tags --always --dirty 2>/dev/null || echo "No version tag")"
	@echo "Commit:      $$(git rev-parse --short HEAD 2>/dev/null || echo 'unknown')"
	@echo "Build Time:  $$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
	@echo "OS-Arch:     $$(go env GOOS)-$$(go env GOARCH)"
	@echo "Go-Version:  $$(go version | awk '{print $$3}' | sed 's/go//')"

## misc/no-dirty: Ensure working tree is clean (no uncommitted changes)
.PHONY: no-dirty
no-dirty:
	git diff --exit-code

## misc/help: Show this help message
.PHONY: help
help:
	@awk -v section_maps="$(SECTION_MAPS)" ' \
		BEGIN { \
			n = split(section_maps, arr, " "); \
			for (i = 1; i <= n; i++) { \
				split(arr[i], kv, ":"); \
				if (length(kv) == 2) section_map[kv[1]] = kv[2]; \
			} \
		} \
		/^##[ ]*/ { \
			line = $$0; \
			sub(/^##[ ]*/, "", line); \
			colon_pos = index(line, ":"); \
			if (colon_pos) { \
				head = substr(line, 1, colon_pos - 1); \
				desc = substr(line, colon_pos + 1); \
				slash_pos = index(head, "/"); \
				if (slash_pos) { \
					section = substr(head, 1, slash_pos - 1); \
					target = substr(head, slash_pos + 1); \
					section_lower = tolower(section); \
					help[section_lower] = help[section_lower] sprintf("  \033[36m%-18s\033[0m%s\n", target, desc); \
					sections[section_lower] = 1; \
				} \
			} \
		} \
		END { \
			n = 0; \
			for (sec in sections) { \
				keys[++n] = sec; \
			} \
			for (i = 1; i <= n; i++) { \
				for (j = i + 1; j <= n; j++) { \
					if (keys[i] > keys[j]) { \
						temp = keys[i]; \
						keys[i] = keys[j]; \
						keys[j] = temp; \
					} \
				} \
			} \
			for (i = 1; i <= n; i++) { \
				sec = keys[i]; \
				display_sec = (sec in section_map) ? section_map[sec] : toupper(substr(sec, 1, 1)) substr(sec, 2); \
				printf "%s\n", display_sec; \
				printf "%s", help[sec]; \
			} \
		} \
	' $(MAKEFILE_LIST)
	@echo ""
	@echo "Current Go version: $$(go version | awk '{print $$3}' | sed 's/go//')"

## misc/list: List all available make targets
.PHONY: list
list:
	@awk ' \
		/^##[ ]*/ { \
			line = $$0; \
			sub(/^##[ ]*/, "", line); \
			colon_pos = index(line, ":"); \
			if (colon_pos) { \
				head = substr(line, 1, colon_pos - 1); \
				split(head, parts, "/"); \
				target = (length(parts) > 1) ? parts[2] : head; \
				printf "  %s\n", target; \
			} \
		} \
	' $(MAKEFILE_LIST) | sort
