#!/usr/bin/env nextflow

// Usage: nextflow run main.nf --reads "data/*_R{1,2}.fq.gz" -profile slurm,singularity --mode "fastqc"
// INIT: nextflow run main.nf -profile singularity,init
// TEST: nextflow run main.nf -profile singularity,test -resume
// QC: nextflow run main.nf -profile singularity,slurm --reads "data/*_R{1,2}.fq.gz" --mode "fastqc"
// CLEAN READS: nextflow run main.nf -profile singularity,slurm --reads "data/*_R{1,2}.fq.gz" --mode "clean"
// ALL: nextflow run main.nf -profile singularity,slurm --reads "data/*_R{1,2}.fq.gz" --mode "all"

nextflow.enable.dsl=2

include { FASTQC; CLEAN_READS } from "./modules/quality_control"
include { MERGE_READS; PLASS; RNASPADES } from "./modules/assembly"
include { GENE_PRED; RENAME_GENES } from "./modules/gene_pred"
include { SALMON_IDX; SALMON_QUANT } from "./modules/quatify"
include { EMAPPER; BARRNAP; PHROG } from "./modules/annotation"
include { MULTIQC } from "./modules/report"


workflow {
    // QUALITY CONTROL
    raw_reads_ch = channel.fromFilePairs(params.reads)
    FASTQC(raw_reads_ch)
    CLEAN_READS(raw_reads_ch)

    if( params.mode == "fastqc" ) {
        MULTIQC(FASTQC.out.fastqc_results_ch.collect())
    }
    else {
        MULTIQC(FASTQC.out.fastqc_results_ch.flatten().concat(CLEAN_READS.out.fastp_json_ch.flatten()).collect())
    }

    CLEAN_READS_ALL = CLEAN_READS.out.fastp_clean_ch.collect()
    MERGE_READS(CLEAN_READS_ALL)
    // PLASS(MERGE_READS.out.reads)
    RNASPADES(MERGE_READS.out.reads)
    GENE_PRED(RNASPADES.out.contigs_soft)
    RENAME_GENES(GENE_PRED.out.gene_fna, GENE_PRED.out.prot_faa)

    SALMON_IDX(RENAME_GENES.out.ref_gene_ch)
    refidx = SALMON_IDX.out.salmon_idx_ch
    SALMON_QUANT(refidx, CLEAN_READS.out.clean_reads_paired_ch)

    // Annotation
    EMAPPER(RENAME_GENES.out.ref_prot_ch)
    BARRNAP(RENAME_GENES.out.ref_prot_ch)
    PHROG(RENAME_GENES.out.ref_prot_ch)
}


workflow.onComplete {
    log.info ( workflow.success ? "\nDone!" : "Oops .. something went wrong" )
}
