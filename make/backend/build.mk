# build.mk - Build and run targets for Go backend services

SECTION_MAPS += build:Build

## build/build: Build the Go application locally
.PHONY: build
build:
	@echo "Building $(MODULE)..."
	@mkdir -p $(BIN_DIR)
	go build $(GOFLAGS) -o $(BIN_DIR)/$(notdir $(MODULE)) $(BOOTSTRAP)

## build/run: Run the Go application locally
.PHONY: run
run:
	@echo "Running $(MODULE)..."
	go run $(BOOTSTRAP)

## build/docker-build: Build the Docker image for the service
.PHONY: docker-build
docker-build:
	@echo "Building Docker image $(DOCKER_IMAGE):$(DOCKER_TAG)..."
	docker build -t $(DOCKER_IMAGE):$(DOCKER_TAG) .

## build/docker-run: Run the service in Docker
.PHONY: docker-run
docker-run:
	@echo "Running $(DOCKER_IMAGE):$(DOCKER_TAG) in Docker..."
	docker run --rm -it -p 8080:8080 $(DOCKER_IMAGE):$(DOCKER_TAG)
