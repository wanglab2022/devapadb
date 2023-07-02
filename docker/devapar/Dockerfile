FROM rocker/r-base:4.3.0

LABEL maintainer="Jinlong Ru"

RUN apt-get update -y && apt-get install -y  libicu-dev make pandoc  make libcurl4-openssl-dev  libxml2-dev  make  libcurl4-openssl-dev libssl-dev  libicu-dev  make zlib1g-dev  libssl-dev libcurl4-openssl-dev  pandoc  libssl-dev  libpng-dev  libxml2-dev make libcurl4-openssl-dev && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /usr/local/lib/R/etc/ /usr/lib/R/etc/
RUN echo "options(renv.config.pak.enabled = TRUE, repos = c(CRAN = 'https://cran.rstudio.com/'), download.file.method = 'libcurl', Ncpus = 4)" | tee /usr/local/lib/R/etc/Rprofile.site | tee /usr/lib/R/etc/Rprofile.site
RUN R -e 'install.packages(c("renv","remotes"))'
COPY ./docker/devapar/renv.lock renv.lock
RUN R -e 'renv::restore()'
