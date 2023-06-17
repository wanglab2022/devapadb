process STAR_INDEX {
    label "devapa"

    input:
    path(ref_fasta)
    val(prefix)

    output:
    path("star_index_$prefix"), emit: ch_star_index

    when:
    task.ext.when == null || task.ext.when

    """
    STAR --runThreadN $task.cpus \\
        --runMode genomeGenerate \\
        --genomeDir star_index_$prefix \\ ##索引生成的文件夹
        --genomeFastaFiles $ref_fasta \\ # hg38.fa 参考基因组的序列文件
        --sjdbGTFfile $ref_gtf \\ # hg38.gtf 参考基因组的注释文件
        --sjdbOverhang 100
    """
}


process STAR_ALIGN {
    label "devapa"

    input:
    path(ref_fasta)
    val(prefix)

    output:
    path("star_index_$prefix"), emit: ch_star_index

    when:
    task.ext.when == null || task.ext.when

    """
    STAR \\
        --outWigType wiggle --outWigStrand Stranded \\
        --outWigNorm RPM \\
        --outSAMtype BAM SortedByCoordinate \\ ##生成的bam文件按坐标排序
        --quantMode TranscriptomeSAM GeneCounts \\
        --runThreadN 10 \\
        --sjdbGTFfile  ./data/hg38.gtf \\ ##参考基因组的注释文件
        --outReadsUnmapped Fastx \\
        --outMultimapperOrder Random \\
        --genomeDir star_index \\ ##上一步生成的索引文件
        --readFilesIn ERR2598067out.fastq.gz \\ ##过滤之后的原始的测序文件
        --outFileNamePrefix  human \\ ##生成文件的前缀
        --readFilesCommand gunzip -c
    """
}



process SALMON_INDEX {
    label "devapa_salmon"

    input:
    path(ref_fasta)
    val(prefix)

    output:
    path("star_index_$prefix"), emit: ch_star_index

    when:
    task.ext.when == null || task.ext.when

    """
    salmon index -t refMrna.fa -i hg38.transcripts_index
    """
}


process SALMON_QUANT {
    label "devapa_salmon"

    input:
    path(ref_fasta)
    val(prefix)

    output:
    path("star_index_$prefix"), emit: ch_star_index

    when:
    task.ext.when == null || task.ext.when

    """
    salmon quant -i hg38.transcripts_index -l A --validateMappings lenient -r ERR2598067out.fastq -o salmon_quant
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
