process DAPARS2 {
    label "devapa"

    input:
    val(input)
    path(refbed)
    path(ref2symbol)

    output:
    path("dapars2_result.tsv"), emit: ch_dapars2_tsv

    when:
    task.ext.when == null || task.ext.when

    script:
    def sample_ids = [], bam_files = []
    for (i in input) {
        // replace "_T[0-9]+" in i[0].id with ""
        // sample_ids.add(i[0].id.replaceAll("_T[0-9]+", ""))
        sample_ids.add(i[0].id)
        bam_files.add(i[1])
    }
    """
    paste <(echo "${sample_ids.join('\n')}") <(echo "${bam_files.join('\n')}") > sample_bam_list.tsv
    prepare_inputs_for_apa_quant.sh -s sample_bam_list.tsv -g $refbed -r $ref2symbol
    cut -f1 refseq_3utr_annotation.bed | sort -u | grep -v "MT" > chrList.txt
    DaPars2_Multi_Sample_Multi_Chr.py Dapars2_running_configure.txt chrList.txt
    parse_dapars2.py -o dapars2_result.tsv
    """
}


process rst_salmon {
    label "r"

    input:
    val(species)
    path(ref2symbol)
    path(salmon_output)

    output:
    path("*.rds"), emit: ch_rst_salmon_rds

    when:
    task.ext.when == null || task.ext.when

    script:
    """
    Rscript create_tximeta.r -s $salmon_output -r $ref2symbol -f salmon_${species}.rds
    """
}
