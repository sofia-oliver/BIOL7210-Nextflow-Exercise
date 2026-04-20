#!/usr/bin/env nextflow
nextflow.enable.dsl=2

include { FASTP } from './modules/FASTP.nf'
include { SKESA } from './modules/SKESA.nf'
include { SEQKIT } from './modules/SEQKIT.nf'


workflow {

    reads_ch = Channel.fromFilePairs("data/mini_fastqs/*_{1,2}.mini.fastq.gz")


    cleaned = FASTP(reads_ch)

    SKESA(cleaned)
    SEQKIT(cleaned)
}