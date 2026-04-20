process SKESA {

    conda 'envs/skesa.yml'

    publishDir "${params.outdir}", mode: 'copy'

    input:
    tuple val(sample_id), path(clean_read1), path(clean_read2)


    output:
    path "${sample_id}.assembly.mini.fasta"

    script:
    """
    skesa \
      --reads ${clean_read1},${clean_read2} \
      --contigs_out ${sample_id}.assembly.mini.fasta
    
    """
}