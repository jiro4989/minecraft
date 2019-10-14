FROM ubuntu:19.04 AS setup

ARG NODE_EXPORTER_VERSION="0.18.1"
ARG NODE_EXPORTER_FILE="node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64"
ARG GROK_EXPORTER_VERSION="0.2.8"
ARG GROK_EXPORTER_FILE="grok_exporter-${GROK_EXPORTER_VERSION}.linux-amd64"

RUN apt update -yqq \
    && apt install -y --no-install-recommends wget ca-certificates unzip

# node_exporter (for prometheus)
RUN wget --tries=3 -qO /opt/${NODE_EXPORTER_FILE}.tar.gz https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/${NODE_EXPORTER_FILE}.tar.gz \
    && (cd /opt && tar xzf ${NODE_EXPORTER_FILE}.tar.gz) \
    && (ln -sfn /opt/${NODE_EXPORTER_FILE} /opt/node_exporter)

# grok_exporter
RUN wget --tries=3 -qO /opt/${GROK_EXPORTER_FILE}.zip https://github.com/fstab/grok_exporter/releases/download/v${GROK_EXPORTER_VERSION}/${GROK_EXPORTER_FILE}.zip \
    && (cd /opt && unzip ${GROK_EXPORTER_FILE}.zip) \
    && (ln -sfn /opt/${GROK_EXPORTER_FILE} /opt/grok_exporter)

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

# grok_exporter
COPY --from=setup /opt/grok_exporter /opt/grok_exporter

# supervisor
# supervisorをforegroundで起動する
RUN sed -iE 's@^\[supervisord\]$@&\nnodaemon=true@g' /etc/supervisor/supervisord.conf

# Log
RUN install -d -o minecraft -g minecraft -m 0755 /var/log/minecraft \
    && install -d -o root -g root -m 0755 /var/log/node_exporter \
    && install -d -o root -g root -m 0755 /var/log/grok_exporter

ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64

ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
