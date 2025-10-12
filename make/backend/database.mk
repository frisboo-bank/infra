# development.mk - Development targets

SECTION_MAPS += db:Database

# Local DB info
DB_POSTGRES_IMAGE ?= postgres:alpine
DB_MONGO_IMAGE ?= mongo:latest

DB_TYPE ?=
DB_CONTAINER_NAME ?=
DB_PORT ?=
DB_USER ?=
DB_PASS ?=
DB_NAME ?=

## db/db-create-container: create all db containers
.PHONY: db-create-container
db-create-container: $(addprefix db-create-container-,$(DB_TARGETS))

## db/db-create-container-<target>: create specific db container
.PHONY: db-create-container-%
db-create-container-%:
	@$(MAKE) _db-create-container DB_TARGET=$*

## db/db-migrate: migrate all databases
.PHONY: db-migrate
db-migrate: $(addprefix db-migrate-,$(DB_TARGETS))

## db/db-migrate-container-<target>: migrate specific database
.PHONY: db-migrate-%
db-migrate-%:
	@$(MAKE) _db-migrate DB_TARGET=$*

## db/db-reset: reset all databases
.PHONY: db-reset
db-reset: $(addprefix db-reset-,$(DB_TARGETS))

## db/db-reset-container-<target>: reset specific database
.PHONY: db-reset-%
db-reset-%:
	@$(MAKE) _db-reset DB_TARGET=$*

.PHONY: _db-create-container
_db-create-container:
	@ask() { \
		read -p "$$1 [y/N] " ans; \
		case "$$ans" in \
			y|Y|yes|YES) return 0 ;; \
			*) return 1 ;; \
		esac \
	};
	\
	error() { echo "Error: $$1" >&2; exit 1; }; \
	\
	DB_TYPE=$(call get-db-var,$(DB_TARGET),DB_TYPE); \
	DB_CONTAINER_NAME=$(call get-db-var,$(DB_TARGET),DB_CONTAINER_NAME); \
	DB_PORT=$(call get-db-var,$(DB_TARGET),DB_PORT); \
	DB_USER=$(call get-db-var,$(DB_TARGET),DB_USER); \
	DB_PASS=$(call get-db-var,$(DB_TARGET),DB_PASS); \
	DB_NAME=$(call get-db-var,$(DB_TARGET),DB_NAME);
	\
	echo "Target: $(DB_TARGET)"; \
	echo "Type: $$DB_TYPE, Container: $$DB_CONTAINER_NAME, Port: $$DB_PORT"; \
	\
	containerId=$$(docker ps -aq -f "name=^$$DB_CONTAINER_NAME$$"); \
	if [ -n "$$containerId" ]; then \
		echo "DB container $$DB_CONTAINER_NAME already exists."; \
		ask "Do you want to remove and recreate it?" || exit 1; \
		echo "Removing existing container..."; \
		docker rm -f "$$containerId"; \
	fi; \
	echo "Creating DB container $$DB_CONTAINER_NAME"; \
	case "$$DB_TYPE" in \
	  mongodb) \
			echo "Building a MongoDB container"; \
			docker run --name $$DB_CONTAINER_NAME \
				-p $$DB_PORT:27017 \
				-e MONGO_INITDB_ROOT_USERNAME=$$DB_USER \
				-e MONGO_INITDB_ROOT_PASSWORD=$$DB_PASS \
				-e MONGO_INITDB_DATABASE=$$DB_NAME \
				-d $(DB_MONGO_IMAGE) || error "Failed to create MongoDB container"; \
			;; \
	  postgres) \
			echo "Building a PostgresSQL container"; \
			docker run --name $$DB_CONTAINER_NAME \
				-p $$DB_PORT:5432 \
				-e POSTGRES_DB=$$DB_NAME \
				-e POSTGRES_USER=$$DB_USER \
				-e POSTGRES_PASSWORD=$$DB_PASS \
				-d $(DB_POSTGRES_IMAGE) || error "Failed to create PostgreSQL container"; \
			;; \
		*) \
			error "DB type $$DB_TYPE not supported. Use 'mongo' or 'postgres'."; \
			;; \
	esac;
	\
	echo "DB container $$DB_CONTAINER_NAME created successfully on port $$DB_PORT"

.PHONY: _db-migrate
_db-migrate:
	@DB_NAME=$(call get-db-var,$(DB_TARGET),DB_NAME); \
	echo "Migrate Database $$DB_NAME"; \
	go run cmd/migrations/main.go up $$DB_NAME;

.PHONY: _db-reset
_db-reset:
	DB_CONTAINER_NAME=$(call get-db-var,$(DB_TARGET),DB_CONTAINER_NAME); \
	echo "Reset Database $$DB_NAME"; \
	go run cmd/migrations/main.go reset $$DB_NAME;

# Function to get database configuration - fixed version
get-db-var = $(if $($1.$2),$($1.$2),$($2))
