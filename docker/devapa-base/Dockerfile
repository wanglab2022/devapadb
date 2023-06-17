FROM 3utr/3aqtl_pipe:miniv4

LABEL author="Jinlong Ru"

USER root

# Activate conda env during docker build
# ARG MAMBA_DOCKERFILE_ACTIVATE=1
# Set PATH manually, because nextflow doesn't activate base env by default.
# ENV PATH=/opt/conda/bin:$PATH

# Copy conda env files
COPY ./docker/devapa-base/env_*.yml /tmp

# Install packages
# RUN --mount=type=cache,target=/opt/conda/pkgs micromamba install -n base -f /tmp/env_base.yml -y
RUN conda env update -n base -f /tmp/env_base.yml

# clean
# RUN micromamba clean --all --yes
