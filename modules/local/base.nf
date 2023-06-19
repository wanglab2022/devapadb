process DAPARS2 {
    label "devapa"

    input:
    val(input)
    path(refbed)
    path(ref2symbol)

    output:
    path("sample_bam_list.tsv"), emit: ch_dapars2_tsv

    when:
    task.ext.when == null || task.ext.when

    script:
    def sample_ids = [], bam_files = []
    for (i in input) {
        // replace "_T[0-9]+" in i[0].id with ""
        sample_ids.add(i[0].id.replaceAll("_T[0-9]+", ""))
        bam_files.add(i[1])
    }
    """
    # create a tsv file, first column is sample id, second column is bam file
    paste <(echo "${sample_ids.join('\n')}") <(echo "${bam_files.join('\n')}") > sample_bam_list.tsv
    which prepare_inputs_for_apa_quant.sh
    prepare_inputs_for_apa_quant.sh -s sample_bam_list.tsv -g $refbed -r $ref2symbol
    cut -f1 refseq_3utr_annotation.bed | sort -u | grep -v "MT" > chrList.txt
    DaPars2_Multi_Sample_Multi_Chr.py Dapars2_running_configure.txt chrList.txt

    # combine the Dapars2 results
    for rstdir in \$(ls -d Dapars2_out_*); do
        chrid=\$(echo \$rstdir | sed 's/Dapars2_out_//g')
        # Add the chrid as a new column to the Dapars2 results, separate by tab
        awk -v chrid=\$chrid 'BEGIN{FS=OFS="\t"}{print chrid,\$0}' \$rstdir/Dapars2_result_temp.\${chrid}.txt
    done > Dapars2_result.txt
    """
}



process APA_QUANT {
    label "devapa"

    input:
    path(ref_fasta)
    val(prefix)

    output:
    path("star_index_$prefix"), emit: ch_star_index

    when:
    task.ext.when == null || task.ext.when

    """
    cat refseq_3utr_annotation.bed | cut -f 1|sort|uniq |grep -v "MT" > chrList.txt
    DaPars2_Multi_Sample_Multi_Chr.py Dapars2_running_configure.txt chrList.txt ##计算PDUI值
    """
}



// process STAR_INDEX {
//     label "devapa"

//     input:
//     val(prefix)
//     path(refgenome)
//     path(refgtf)

//     output:
//     path("star_index_$prefix"), emit: ch_star_index

//     when:
//     task.ext.when == null || task.ext.when

//     """
//     STAR \\
//         --genomeFastaFiles $refgenome \\
//         --sjdbGTFfile $refgtf \\
//         --runThreadN $task.cpus \\
//         --runMode genomeGenerate \\
//         --sjdbOverhang 100 \\
//         --genomeDir star_index_$prefix
//     """
// }


// process STAR_ALIGN {
//     label "devapa"

//     input:
//     val(prefix)
//     path(refgtf)
//     path(staridx)
//     path(reads)

//     output:
//     path("$prefix"), emit: ch_star_align

//     when:
//     task.ext.when == null || task.ext.when

//     """
//     STAR \\
//         --sjdbGTFfile  $refgtf \\
//         --genomeDir $staridx \\
//         --readFilesIn $reads \\
//         --runThreadN $task.cpus \\
//         --outWigType wiggle \\
//         --outWigStrand Stranded \\
//         --outWigNorm RPM \\
//         --outSAMtype BAM SortedByCoordinate \\
//         --quantMode TranscriptomeSAM GeneCounts \\
//         --outReadsUnmapped Fastx \\
//         --outMultimapperOrder Random \\
//         --outFileNamePrefix $prefix \\
//         --readFilesCommand gunzip -c
//     """
// }



// process SALMON_INDEX {
//     label "devapa_salmon"

//     input:
//     path(refrna)
//     val(prefix)

//     output:
//     path("salmon_index_$prefix"), emit: ch_salmon_index

//     when:
//     task.ext.when == null || task.ext.when

//     """
//     salmon index -p $task.cpus -t $refrna -i salmon_index_$prefix
//     """
// }


// process SALMON_QUANT {
//     tag "$meta.id"
//     label "devapa_salmon"

//     input:
//     tuple val(meta), path(reads)
//     path(index)
//     val(prefix)

//     output:
//     path("salmon_quant_$prefix"), emit: ch_salmon_quant

//     when:
//     task.ext.when == null || task.ext.when

//     script:
//     def reference   = "--index $index"
//     def input_reads = meta.single_end ? "-r $reads" : "-1 ${reads[0]} -2 ${reads[1]}"

//     """
//     salmon quant \\
//         -p $task.cpus \\
//         $reference \\
//         $input_reads \\
//         -l A --validateMappings lenient \\
//         -o salmon_quant_$prefix -r $reads
//     """
// }


