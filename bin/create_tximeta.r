#!/usr/bin/env Rscript

library(argparser)
library(tidyverse)
library(data.table)
library(tximport)


p <- arg_parser("Create tximeta object from salmon output")
p <- add_argument(p, "--salmon", help = "salmon quant output directory (cow_salmon)")
p <- add_argument(p, "--ref2symbol", help = "ref2symbol.txt")
p <- add_argument(p, "--fout", help = "output file name")
argv <- parse_args(p)


tx2gene <- fread(p$ref2symbol) %>%
    setnames(colnames(.), c("TXNAME", "GENEID")) %>%
    dplyr::mutate(TXNAME = str_replace(TXNAME, "\\.[0-9]*", ""))


dpath <- p$salmon
sids <- list.files(dpath)
spath <- file.path(dpath, sids)
sfs <- file.path(spath, "quant.sf")
names(sfs) <- str_replace(sids, "_.*", "")

txi <- tximport(sfs, type = "salmon", tx2gene = tx2gene, ignoreTxVersion = TRUE)

saveRDS(txi, file = fout)
