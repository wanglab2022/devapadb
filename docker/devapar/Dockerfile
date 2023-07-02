FROM rocker/r-base:4.3.0
LABEL maintainer="Jinlong Ru"
WORKDIR /app
RUN apt-get update -y && apt-get install -y  libicu-dev  make  libcurl4-openssl-dev libssl-dev  zlib1g-dev  libssl-dev make libcurl4-openssl-dev  make zlib1g-dev  libssl-dev libcurl4-openssl-dev  libssl-dev  pandoc  libfreetype6-dev libfribidi-dev libharfbuzz-dev libfontconfig1-dev libjpeg-dev libpng-dev libtiff-dev  pandoc libicu-dev make  libicu-dev make pandoc  libicu-dev libssl-dev libxml2-dev libcurl4-openssl-dev  libfontconfig1-dev libfreetype6-dev  libfreetype6-dev libfribidi-dev libharfbuzz-dev libfontconfig1-dev  libfreetype6-dev libfribidi-dev libharfbuzz-dev libfontconfig1-dev pandoc libicu-dev libjpeg-dev libpng-dev libtiff-dev zlib1g-dev make libssl-dev libxml2-dev libcurl4-openssl-dev  libxml2-dev && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /usr/local/lib/R/etc/ /usr/lib/R/etc/
RUN echo "options(renv.config.pak.enabled = TRUE, repos = c(CRAN = 'https://cran.rstudio.com/'), download.file.method = 'libcurl', Ncpus = 4)" | tee /usr/local/lib/R/etc/Rprofile.site | tee /usr/lib/R/etc/Rprofile.site
RUN R -e 'install.packages(c("renv","remotes", "BiocManager", "data.table", "here", "argparser", "tidyverse"))'
RUN R -e 'BiocManager::install(c("tximeta"))'
