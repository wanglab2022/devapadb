[![Nextflow](https://img.shields.io/badge/nextflow%20DSL2-%E2%89%A522.10.1-23aa62.svg)](https://www.nextflow.io/)
[![run with conda](http://img.shields.io/badge/run%20with-conda-3EB049?labelColor=000000&logo=anaconda)](https://docs.conda.io/en/latest/)
[![run with docker](https://img.shields.io/badge/run%20with-docker-0db7ed?labelColor=000000&logo=docker)](https://www.docker.com/)
[![run with singularity](https://img.shields.io/badge/run%20with-singularity-1d355c.svg?labelColor=000000)](https://sylabs.io/docs/)

## Introduction

**wanglab2022/devapadb** is a bioinformatic pipeline and database that ...

## Usage

### 1. Prepare data

```
refs
├── ref2symbol.txt       // refseq_id_to_symbol
├── ref.bed              // refseq_whole_gene.bed
├── ref.fa               // Transcriptome FASTA file
├── ref.fasta            // Genome FASTA file
└── ref.gtf              // GTF annotation file

samples.csv
```

### 2. Run pipeline

```sh
# wanglab
nextflow run wanglab2022/devapadb -r dev -profile singularity --input samples.csv

# denglab@LRZ
nextflow run wanglab2022/devapadb -r dev -profile charliecloud,charliecloud_denglab --input samples.csv -resume

# denglab@HMGU
nextflow run wanglab2022/devapadb -r dev -profile singularity,singularity_denglab,slurm_hmgu --input samples.csv -resume
```

## Credits

DevAPAdb was originally written by [Jinlong Ru](https://github.com/rujinlong), [Dingbang Ding](https://github.com/Dingdingbang0514) and Xia Wang.

We thank the following people for their extensive assistance in the development of this pipeline:

## Contributions and Support

If you would like to contribute to this pipeline, please see the [contributing guidelines](.github/CONTRIBUTING.md).
