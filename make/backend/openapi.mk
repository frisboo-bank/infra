# openapi3.mk - OpenAPI targets

SECTION_MAPS += openapi:OpenAPI

OPENAPI_SPEC ?= api/customer-details.yml

## openapi/validate: Validate OpenAPI spec
.PHONY: validate
validate:
	@echo ">> Validating $(OPENAPI_SPEC) with oapi-codegen"
