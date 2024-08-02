ARG SPARK_BASE_IMAGE=spark:3.4.1-scala2.12-java11-python3-r-ubuntu
FROM ${SPARK_BASE_IMAGE}

ARG PYTHON_VENV_PATH=/opt/venv

ENV DEBIAN_FRONTEND=noninteractive

USER root
WORKDIR /

RUN apt-get update &&  apt-get install -y tzdata
RUN apt-get install -y --install-recommends \
      build-essential \
      software-properties-common \
      gdal-bin \
      libgdal-dev  \
      python3-venv \
      tini \
      wget\
      zip \
      && \
      apt-get clean && \
      rm -rf /var/lib/apt/lists/*

#
# Python Setup and Libraries
#

# Activate the virtual environment
RUN python3 -m venv ${PYTHON_VENV_PATH}
ENV PATH="${PYTHON_VENV_PATH}/bin:$PATH"

# Install GDAL
RUN pip3 install --no-cache --force-reinstall gdal[numpy]=="$(gdal-config --version).*"
RUN export CPLUS_INCLUDE_PATH=/usr/include/gdal
RUN export C_INCLUDE_PATH=/usr/include/gdal

COPY spark_requirements.txt .
RUN pip install -r spark_requirements.txt

ENV PYTHONPATH=$SPARK_HOME/python:$PYTHONPATH

#
# Configure Spark
#

# Copy the default configurations into
COPY spark-master-defaults.properties "$SPARK_HOME/conf/spark-defaults.conf"

RUN chmod u+x /opt/spark/sbin/* && \
   chmod u+x /opt/spark/bin/*

USER spark
WORKDIR /opt/spark/work-dir

ENTRYPOINT [ "tini", "--" ]
CMD ["/opt/spark/sbin/start-master.sh"]
