
FROM spark:python3-java17

ARG PYTHON_VENV_PATH=/opt/venv
ENV PYTHON_VENV_PATH=${PYTHON_VENV_PATH}
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
     && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

#
# Python tasks
#

RUN python3 -m venv $PYTHON_VENV_PATH
ENV PATH="$PYTHON_VENV_PATH/bin:$PATH"

# Install GDAL
RUN export CPLUS_INCLUDE_PATH=/usr/include/gdal
RUN export C_INCLUDE_PATH=/usr/include/gdal
RUN pip3 install --upgrade pip
RUN pip install GDAL=="$(gdal-config --version).*"

COPY spark_requirements.txt .
RUN pip3 install --upgrade pip
RUN pip3 install -r spark_requirements.txt

# Copy the default configurations into
COPY spark-master-defaults.properties "$SPARK_HOME/conf/spark-defaults.conf"

RUN chmod u+x /opt/spark/sbin/* && \
   chmod u+x /opt/spark/bin/*

ENV PYTHONPATH=$SPARK_HOME/python:$PYTHONPATH

# Copy appropriate entrpoint
COPY spark_entrypoint.sh /opt/entrypoint.sh

USER spark
WORKDIR /opt/spark/work-dir

ENTRYPOINT ["/opt/entrypoint.sh"]
