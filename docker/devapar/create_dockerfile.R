dir_build <- tempfile(pattern = "renv")
dir.create(dir_build)

# Create a lockfile
the_lockfile <- file.path(dir_build, "renv.lock")
custom_packages <- c(
  # attachment::att_from_description(),
  "tximeta",
  "data.table",
  "tidyverse",
  "here"
)
renv::snapshot(
  packages = custom_packages,
  lockfile = the_lockfile,
  prompt = FALSE
)


my_dock <- dockerfiler::dock_from_renv(lockfile = the_lockfile)
my_dock$MAINTAINER("Jinlong Ru", "jinlong.ru@gmail.com")

my_dock$write("Dockerfile")
