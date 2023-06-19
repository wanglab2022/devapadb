FROM 3utr/3aqtl_pipe:miniv4

LABEL author="Jinlong Ru"

USER root

# Activate conda env during docker build
# ARG MAMBA_DOCKERFILE_ACTIVATE=1
# Set PATH manually, because nextflow doesn't activate base env by default.

# Copy conda env files
COPY ./docker/devapa/env.yml /tmp

# Install packages
# RUN --mount=type=cache,target=/opt/conda/pkgs micromamba install -n base -f /tmp/env_base.yml -y
RUN conda env update -n base -f /tmp/env.yml

# clean
RUN conda clean --all --yes

RUN cd /home && \
    mv 3aQTL_pipe /opt

COPY ./docker/devapa/*.py /opt/3aQTL_pipe/src/
COPY ./docker/devapa/*.sh /opt/3aQTL_pipe/src/
COPY ./docker/devapa/*.R /opt/3aQTL_pipe/src/
RUN chmod +x /opt/3aQTL_pipe/src/*.sh && \
    chmod +x /opt/3aQTL_pipe/src/*.py && \
    chmod +x /opt/3aQTL_pipe/src/*.R

ENV PATH=/opt/3aQTL_pipe/src:/opt/conda/envs/myEnv/bin:$PATH
