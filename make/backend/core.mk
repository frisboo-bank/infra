# core.mk - Shared Makefile logic for all Go backend services & libraries
# This is the main entry point: include all sub-makefiles in order

# Use bash if available
SHELL := $(shell if command -v bash >/dev/null 2>&1; then echo bash; else echo sh; fi)
ifeq ($(SHELL),bash)
.SHELLFLAGS := -euo pipefail -c
else
.SHELLFLAGS := -c
endif

SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

# Include all sub-makefiles
include $(SELF_DIR)/config.mk
include $(SELF_DIR)/utils.mk
include $(SELF_DIR)/checks.mk
include $(SELF_DIR)/database.mk
include $(SELF_DIR)/dependencies.mk
include $(SELF_DIR)/development.mk
include $(SELF_DIR)/misc.mk
include $(SELF_DIR)/openapi.mk
include $(SELF_DIR)/quality.mk
include $(SELF_DIR)/testing.mk
