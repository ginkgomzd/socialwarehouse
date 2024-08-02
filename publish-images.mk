# optionally import CI_REGISTRY, etc.
-include conf/gitlab.env

# **ENVIRONMENT VARIABLES REQUIRED by container-registry.mk**
export CI_REGISTRY
export CI_REGISTRY_USER
export CI_REGISTRY_PASSWORD

#
# To disable publish and just build, set PUBLISH_IMAGE=false
#
PUBLISH_IMAGE ?= true
ifneq ($(PUBLISH_IMAGE),true)
	TARGET = build
else
	TARGET = publish
endif

export NO_CACHE

#
# USE THE SOURCE, LUKE!
# see docker/container-registry.mk
PUBLISH_IMAGE_CMD = $(MAKE) -f docker/container-registry.mk ${TARGET}

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

swh-pycomp:
	$(eval UBUNTU_BASE_IMAGE ?= ubuntu:20.04)
	$(eval PYTHON_VENV_PATH ?= /opt/venv)
	$(eval BUILD_ARGS ?= UBUNTU_BASE_IMAGE=${UBUNTU_BASE_IMAGE} PYTHON_VENV_PATH=${PYTHON_VENV_PATH})
	BUILD_IMAGE_DIR=docker/python-computation \
		IMAGE_NAME=$@ \
		BUILD_ARGS='${BUILD_ARGS}' \
		${PUBLISH_IMAGE_CMD}