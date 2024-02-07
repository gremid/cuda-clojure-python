FROM nvidia/cuda:12.3.1-runtime-ubuntu22.04

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.name="cuda-clojure-python" \
    org.label-schema.description="Base image for Clojure/Python projects with CUDA support" \
    org.label-schema.url="https://github.com/gremid/cuda-clojure-python" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url="https://github.com/gremid/cuda-clojure-python" \
    org.label-schema.vendor="Gregor Middell" \
    org.label-schema.version=$VCS_REF \
    org.label-schema.schema-version="1.0"

## Setup Java and Clojure
##
## cf. https://github.com/Quantisan/docker-clojure/blob/master/target/debian-bullseye-slim-21/tools-deps/Dockerfile

ENV JAVA_HOME=/opt/java/openjdk
COPY --from=eclipse-temurin:21-jammy $JAVA_HOME $JAVA_HOME
ENV PATH="${JAVA_HOME}/bin:${PATH}"

ENV CLOJURE_VERSION=1.11.1.1435

WORKDIR /tmp

RUN \
    apt-get update && \
    apt-get install -y curl make git rlwrap wget && \
    rm -rf /var/lib/apt/lists/* && \
    wget https://download.clojure.org/install/linux-install-$CLOJURE_VERSION.sh && \
    sha256sum linux-install-$CLOJURE_VERSION.sh && \
    echo "7edee5b12197a2dbe6338e672b109b18164cde84bea1f049ceceed41fc4dd10a *linux-install-$CLOJURE_VERSION.sh" | sha256sum -c - && \
    chmod +x linux-install-$CLOJURE_VERSION.sh && \
    ./linux-install-$CLOJURE_VERSION.sh && \
    rm linux-install-$CLOJURE_VERSION.sh && \
    clojure -e "(clojure-version)" && \
    apt-get purge -y --auto-remove curl wget

## Setup Python

RUN apt-get update -y && \
    apt-get install -y python3-pip && \
    rm -rf /var/lib/apt/lists/*
