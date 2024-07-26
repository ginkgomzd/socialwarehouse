# import CI_REGISTRY from conf/gitlab.env
include conf/gitlab.env

# **REQUIRED ENVIRONMENT VARIABLES**
# CI_REGISTRY
# CI_REGISTRY_USER
# CI_REGISTRY_PASSWORD
#
# USE THE SOURCE, LUKE!
# see docker/publish.mk
#

# DO NOT INCLUDE --build-arg flag, just key-value pairs
BUILD_ARGS ?= UBUNTU_BASE_IMAGE=${UBUNTU_BASE_IMAGE} PYTHON_VENV_PATH=${PYTHON_VENV_PATH}

UBUNTU_BASE_IMAGE ?= ubuntu:20.04
PYTHON_VENV_PATH ?= /opt/venv
IMAGE_NAME ?= fec-intelligence/swh-spark-py-gdal

#
# To disable publish and just build, set PUBLISH_IMAGE=false
#
PUBLISH_IMAGE ?= true
ifneq ($(PUBLISH_IMAGE),true)
	TARGET = build
else
	TARGET = publish
endif

PUBLISH_IMAGE_CMD = $(MAKE) -f conf/gitlab.env -f docker/publish.mk ${TARGET}

spark:
	BUILD_IMAGE_DIR=docker/spark \
		IMAGE_NAME=${IMAGE_NAME} \
		BUILD_ARGS='${BUILD_ARGS}' \
		${PUBLISH_IMAGE_CMD}
