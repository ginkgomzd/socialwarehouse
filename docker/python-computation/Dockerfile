# Args from compose
ARG UBUNTU_BASE_IMAGE
FROM ${UBUNTU_BASE_IMAGE}

ARG PYTHON_VENV_PATH=/opt/venv
ENV DEBIAN_FRONTEND=noninteractive

# Install the basics
RUN apt-get update && apt-get install -y tzdata
RUN apt-get install -y --install-recommends \
    build-essential \
    wget \
    ca-certificates \
    libgdal-dev \
    python3-pip \
    python3-venv \
    python3-pyproj \
    postgresql  \
    postgresql-contrib \
    postgis \
    vim \
    tini \
    && apt-get clean

#
# Python tasks
#

# Activate the virtual environment
RUN python3 -m venv ${PYTHON_VENV_PATH}
ENV PATH="${PYTHON_VENV_PATH}/bin:$PATH"

# Install GDAL
RUN pip3 install --no-cache --force-reinstall gdal[numpy]=="$(gdal-config --version).*"
RUN export CPLUS_INCLUDE_PATH=/usr/include/gdal
RUN export C_INCLUDE_PATH=/usr/include/gdal

# Install PIP requirements
ADD requirements.txt /tmp/
RUN pip3 install -r /tmp/requirements.txt

WORKDIR /opt

ENTRYPOINT [ "tini", "--", "python3" ]

CMD ["-m", "http.server", "8000"]
