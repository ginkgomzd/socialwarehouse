
# **REQUIRED ENVIRONMENT VARIABLES**
# CI_REGISTRY
# CI_REGISTRY_USER
# CI_REGISTRY_PASSWORD
# IMAGE_NAME

# OPTIONAL ENVIRONMENT VARIABLES
TAG_NAME ?= $(shell date +v%Y%m%d-%H%M%S)
CI_REGISTRY_IMAGE ?= ${CI_REGISTRY}/${IMAGE_NAME}
# DO NOT INCLUDE --build-arg flag, just key-value pairs (space separated)
BUILD_ARGS ?=
BUILD_IMAGE_DIR ?= $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

# use docker build cache by default
ifndef NO_CACHE
NO_CACHE=
else
NO_CACHE=--no-cache
endif

publish: login build
	docker push --all-tags ${CI_REGISTRY_IMAGE}

build:
	docker build ${NO_CACHE} \
	$(foreach key_val, ${BUILD_ARGS}, --build-arg ${key_val}) \
	${BUILD_IMAGE_DIR} \
	-t ${CI_REGISTRY_IMAGE}:${TAG_NAME} \
	-t ${CI_REGISTRY_IMAGE}:latest

login:
	# Loging in to the GitLab Container Registry ${CI_REGISTRY}
	@docker login -u ${CI_REGISTRY_USER} -p ${CI_REGISTRY_PASSWORD} ${CI_REGISTRY}

