ARG SPARK_BASE_IMAGE=spark:3.4.1-scala2.12-java11
ARG ZEPPELIN_BASE_IMAGE=apache/zeppelin:0.11.2

FROM ${SPARK_BASE_IMAGE} as spark

FROM ${ZEPPELIN_BASE_IMAGE}

USER root

COPY --from=spark /opt/spark /opt/spark
ENV SPARK_HOME=/opt/spark

RUN chown -R 1000:1000 /opt/zeppelin
RUN chown -R 1000:1000 /opt/spark

# address sloppy distro image:
# https://stackoverflow.com/a/78697284
RUN	find /opt -type f -name '._*' -exec rm -f {} +

USER 1000
WORKDIR /opt/zeppelin
