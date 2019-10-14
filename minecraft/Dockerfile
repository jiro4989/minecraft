FROM ubuntu:19.04 AS setup

ARG NODE_EXPORTER_VERSION="0.18.1"
ARG NODE_EXPORTER_FILE="node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64"

RUN apt update -yqq \
    && apt install -y --no-install-recommends wget ca-certificates

# node_exporter (for prometheus)
RUN mkdir -p /opt/node_exporter/bin \
    && wget --tries=3 -qO /opt/${NODE_EXPORTER_FILE}.tar.gz https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/${NODE_EXPORTER_FILE}.tar.gz \
    && (cd /opt && tar xzf ${NODE_EXPORTER_FILE}.tar.gz) \
    && install -m 0755 /opt/${NODE_EXPORTER_FILE}/node_exporter /opt/node_exporter/bin/node_exporter

################################################################################

FROM ubuntu:19.04 AS runtime

RUN apt update -yqq \
    && apt install -y --no-install-recommends supervisor openjdk-11-jdk

# Minecraft
RUN mkdir -p /opt/minecraft/bin /opt/minecraft/data \
    && useradd minecraft \
    && chown -R minecraft: /opt/minecraft

# node_exporter
COPY --from=setup /opt/node_exporter /opt/node_exporter

# supervisor
# supervisorをforegroundで起動する
RUN sed -iE 's@^\[supervisord\]$@&\nnodaemon=true@g' /etc/supervisor/supervisord.conf

# Log
RUN install -d -o minecraft -g minecraft -m 0755 /var/log/minecraft \
    && install -d -o root -g root -m 0755 /var/log/node_exporter

ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64

ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
