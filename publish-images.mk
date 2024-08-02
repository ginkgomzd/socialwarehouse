# import CI_REGISTRY from conf/gitlab.env
include conf/gitlab.env

# **REQUIRED ENVIRONMENT VARIABLES**
# CI_REGISTRY
# CI_REGISTRY_USER
# CI_REGISTRY_PASSWORD
#
# USE THE SOURCE, LUKE!
# see docker/container-registry.mk
#

#
# To disable publish and just build, set PUBLISH_IMAGE=false
#
PUBLISH_IMAGE ?= true
ifneq ($(PUBLISH_IMAGE),true)
	TARGET = tag
else
	TARGET = publish
endif

PUBLISH_IMAGE_CMD = $(MAKE) -f conf/gitlab.env -f docker/container-registry.mk ${TARGET}

swh-spark-py-gdal:
	$(eval UBUNTU_BASE_IMAGE ?= ubuntu:20.04)
	$(eval PYTHON_VENV_PATH ?= /opt/venv)
	$(eval BUILD_ARGS ?= UBUNTU_BASE_IMAGE=${UBUNTU_BASE_IMAGE} PYTHON_VENV_PATH=${PYTHON_VENV_PATH})
	BUILD_IMAGE_DIR=docker/spark \
		IMAGE_NAME=$@ \
		BUILD_ARGS='${BUILD_ARGS}' \
		${PUBLISH_IMAGE_CMD}

swh-zeppelin:
	BUILD_IMAGE_DIR=docker/zeppelin \
		IMAGE_NAME=$@ \
		BUILD_ARGS='SPARK_BASE_IMAGE=spark:3.4.1-scala2.12-java11-python3-r-ubuntu' \
		${PUBLISH_IMAGE_CMD}
