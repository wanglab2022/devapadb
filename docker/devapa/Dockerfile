FROM mambaorg/micromamba:1.4.4

LABEL author="Jinlong Ru"

USER root

# Activate conda env during docker build
ARG MAMBA_DOCKERFILE_ACTIVATE=1
# Set PATH manually, because nextflow doesn't activate base env by default.
ENV PATH=/opt/conda/bin:$PATH

# Copy conda env files
COPY ./docker/devapa/env.yml /tmp

# Install packages
RUN --mount=type=cache,target=/opt/conda/pkgs micromamba install -n base -f /tmp/env.yml -y

# clean
RUN micromamba clean --all --yes
