# development.mk - Development targets

SECTION_MAPS += db:Database

# Local DB info
DB_BASE_IMAGE ?= postgres:alpine
DB_CONTAINER_NAME ?= $(NAME)-db
DB_HOST ?= localhost
DB_PORT ?= 5432
DB_NAME ?= $(NAME)
DB_USER ?= postgres
DB_PASS ?= postgres
DB_SSL_MODE ?= disable

## db/db-create-container: create a db container
.PHONY: db-create-container
db-create-container:
	@ask() { \
		read -p "$$1 [y/N] " ans; \
		case "$$ans" in \
			y|Y|yes|YES) return 0 ;; \
			*) return 1 ;; \
		esac \
	}; \
	containerPid=$$(docker ps -aq -f name=$(DB_CONTAINER_NAME)); \
	if [ -n "$$containerPid" ]; then \
		echo "DB container $(DB_CONTAINER_NAME) already exists."; \
		ask "Do you want to continue?" || exit 1; \
		echo "Pruning..."; \
		docker rm -f "$$containerPid"; \
	fi; \
	echo "Creating DB container $(DB_CONTAINER_NAME)"; \
	docker run --name $(DB_CONTAINER_NAME) -p $(DB_PORT):5432 -e POSTGRES_DB=$(DB_NAME) -e POSTGRES_USER=$(DB_USER) -e POSTGRES_PASSWORD=$(DB_PASS) -d $(DB_BASE_IMAGE);
