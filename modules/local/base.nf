process STAR_INDEX {
    label "devapa"

    input:
    val(prefix)
    path(refgenome)
    path(refgtf)

    output:
    path("star_index_$prefix"), emit: ch_star_index

    when:
    task.ext.when == null || task.ext.when

    """
    STAR \\
        --genomeFastaFiles $refgenome \\
        --sjdbGTFfile $refgtf \\
        --runThreadN $task.cpus \\
        --runMode genomeGenerate \\
        --sjdbOverhang 100 \\
        --genomeDir star_index_$prefix
    """
}


process STAR_ALIGN {
    label "devapa"

    input:
    val(prefix)
    path(refgtf)
    path(staridx)
    path(reads)

    output:
    path("$prefix"), emit: ch_star_align

    when:
    task.ext.when == null || task.ext.when

    """
    STAR \\
        --sjdbGTFfile  $refgtf \\
        --genomeDir $staridx \\
        --readFilesIn $reads \\
        --runThreadN $task.cpus \\
        --outWigType wiggle \\
        --outWigStrand Stranded \\
        --outWigNorm RPM \\
        --outSAMtype BAM SortedByCoordinate \\
        --quantMode TranscriptomeSAM GeneCounts \\
        --outReadsUnmapped Fastx \\
        --outMultimapperOrder Random \\
        --outFileNamePrefix $prefix \\
        --readFilesCommand gunzip -c
    """
}



process SALMON_INDEX {
    label "devapa_salmon"

    input:
    path(refrna)
    val(prefix)

    output:
    path("salmon_index_$prefix"), emit: ch_salmon_index

    when:
    task.ext.when == null || task.ext.when

    """
    salmon index -p $task.cpus -t $refrna -i salmon_index_$prefix
    """
}


process SALMON_QUANT {
    tag "$meta.id"
    label "devapa_salmon"

    input:
    tuple val(meta), path(reads)
    path(index)
    val(prefix)

    output:
    path("salmon_quant_$prefix"), emit: ch_salmon_quant

    when:
    task.ext.when == null || task.ext.when

    script:
    def reference   = "--index $index"
    def input_reads = meta.single_end ? "-r $reads" : "-1 ${reads[0]} -2 ${reads[1]}"

    """
    salmon quant \\
        -p $task.cpus \\
        $reference \\
        $input_reads \\
        -l A --validateMappings lenient \\
        -o salmon_quant_$prefix -r $reads
    """
}


process DAPARS2 {
    label "devapa"

    input:
    path(ref_fasta)
    val(prefix)

    output:
    path("star_index_$prefix"), emit: ch_star_index

    when:
    task.ext.when == null || task.ext.when

    """
    prepare_inputs_for_apa_quant.sh -s sample_list.txt -g hg38_refseq_whole_gene.bed -r hg38_refseq_id_to_symbol.txt
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
