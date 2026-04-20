process FASTP {

    conda 'envs/fastp.yml'

    publishDir "${params.outdir}", mode: 'copy'

    input:
    tuple val(sample_id), path(reads)

    output:

    tuple val(sample_id),
        path("${sample_id}_1.clean.mini.fastq.gz"),
        path("${sample_id}_2.clean.mini.fastq.gz")

    script:
    """
    fastp \
      -i ${reads[0]} \
      -I ${reads[1]} \
      -o ${sample_id}_1.clean.mini.fastq.gz \
      -O ${sample_id}_2.clean.mini.fastq.gz

    """
}