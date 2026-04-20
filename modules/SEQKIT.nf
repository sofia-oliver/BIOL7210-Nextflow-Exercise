process SEQKIT {

    conda 'envs/seqkit.yml'

    publishDir "${params.outdir}", mode: 'copy'

    input:

    tuple val(sample_id), path(clean_read1), path(clean_read2)

    output:
    path "${sample_id}.seqkit.mini.txt"

    script:
    """
    seqkit stats ${clean_read1} ${clean_read2} > ${sample_id}.seqkit.mini.txt

    """
}