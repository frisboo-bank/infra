# development.mk - Development targets

SECTION_MAPS += db:Database

# Local DB info
DB_TYPE ?=
DB_POSTGRES_IMAGE ?= postgres:alpine
DB_MONGO_IMAGE ?= mongo:latest

## db/db-create-container: create the db container
.PHONY: db-create-container
db-create-container:
	@ask() { \
		read -p "$$1 [y/N] " ans; \
		case "$$ans" in \
			y|Y|yes|YES) return 0 ;; \
			*) return 1 ;; \
		esac \
	}; \
	error() { echo "Error: $$1" >&2; exit 1; }; \
	containerPid=$$(docker ps -aq -f name=$(DB_CONTAINER_NAME)); \
	if [ -n "$$containerPid" ]; then \
		echo "DB container $(DB_CONTAINER_NAME) already exists."; \
		ask "Do you want to remove and recreate it?" || exit 1; \
		echo "Removing existing container..."; \
		docker rm -f "$$containerPid"; \
	fi; \
	echo "Creating DB container $(DB_CONTAINER_NAME)"; \
	case "$(DB_TYPE)" in \
	  mongodb) \
			echo "Building a MongoDB container"; \
			docker run --name $(DB_CONTAINER_NAME) \
				-p $(DB_PORT):27017 \
				-e MONGO_INITDB_ROOT_USERNAME=$(DB_USER) \
				-e MONGO_INITDB_ROOT_PASSWORD=$(DB_PASS) \
				-e MONGO_INITDB_DATABASE=$(DB_NAME) \
				-d $(DB_MONGO_IMAGE) || error "Failed to create MongoDB container"; \
			;; \
	  postgres) \
			echo "Building a PostgresSQL container"; \
			docker run --name $(DB_CONTAINER_NAME) \
				-p $(DB_PORT):5432 \
				-e POSTGRES_DB=$(DB_NAME) \
				-e POSTGRES_USER=$(DB_USER) \
				-e POSTGRES_PASSWORD=$(DB_PASS) \
				-d $(DB_POSTGRES_IMAGE) || error "Failed to create PostgreSQL container"; \
			;; \
		*) \
			error "DB type $(DB_TYPE) not supported. Use 'mongo' or 'postgres'."; \
			;; \
	esac; \
	echo "DB container $(DB_CONTAINER_NAME) created successfully on port $(DB_PORT)"

## db/db-create: create database
.PHONY: db-create
db-create:
	echo "Creating DB $(DB_NAME)"; \
	docker exec -it $(DB_CONTAINER_NAME) createdb -U $(DB_USER) -O $(DB_PASS) $(DB_NAME)

## db/db-drop: drop database
.PHONY: db-create
db-drop:
	echo "Drop DB $(DB_NAME)"; \
	docker exec -it $(DB_CONTAINER_NAME) dropdb -U $(DB_USER) $(DB_NAME)
