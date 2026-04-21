# BIOL7210 Nextflow Exercise

# Nextflow Genome Assembly Pipeline (FASTP → SKESA → SEQKIT)

## Overview

This workflow processes paired-end FASTQ sequencing data using a reproducible Nextflow pipeline. It performs:

1. Quality control and trimming using **FASTP**
2. De novo genome assembly using **SKESA**
3. Read quality statistics using **SEQKIT**

The workflow supports sequential and parallel execution.

<img width="316" height="312" alt="graphviz" src="https://github.com/user-attachments/assets/cffdef39-093a-4e16-8b4c-9faed053b655" />


---

## Test Data

Test data is included in this repository in the following directory:

`data/mini_fastqs/`

This directory contains paired-end FASTQ files used for testing the pipeline:

*Legionella pneumophila* 
SRA accession number: SRR28703335

- SRR28703325_1.mini.fastq.gz  
- SRR28703325_2.mini.fastq.gz  

These paired-end reads are automatically detected and grouped using Nextflow’s `fromFilePairs` operator:

```nextflow
Channel.fromFilePairs("data/mini_fastqs/*_{1,2}.mini.fastq.gz")
```
### Note about test data + workflow

The mini fastq files were created from a subset of 30,000 reads from the original fastq files (SRR28703335). The workflow is compatible with full fastQ files, but for storage and efficiency purposes, mini fastQ files were used. All notation contains "mini" for clarity, but the workflow is scalable to full fastQ files. 

Original files were fetched using sra-tools and fastqc with the following commands:

```bash
prefetch SRR28703325
fasterq-dump "SRR28703325/SRR28703325.sra" --outdir . --split-files --skip-technical
```

---

##  Requirements

### Software Environment

- **Nextflow version:** 25.10.4
- **Package manager:** conda
- **Package manager version:** 25.7.0

### System

- **Operating System:** Ubuntu 24.04.3 LTS (WSL2 on Windows 11)
- **Architecture:** x86_64

---

## Set-up and Execution
To exectute the pipeline, first create the nextflow environment: 

```bash
conda create -n nf -c bioconda nextflow -y
conda activate nf
```
### Directory Structure
Ensure your directory structure is as follows:
```text
.
├── README.md
├── data
│   └── mini_fastqs
├── envs ------> handles other conda environment setup in pipeline
│   ├── fastp.yml
│   ├── seqkit.yml
│   └── skesa.yml
│
├── main.nf
├── modules
│   ├── FASTP.nf
│   ├── SEQKIT.nf
│   └── SKESA.nf
├── nextflow.config

```
### Execution
Then, run the pipeline

```bash
nextflow run main.nf --reads data/mini_fastqs/*.fastq.gz 
```
### Outputs
.
results
├── SRR28703325.assembly.mini.fasta --> skesa assembly file (.fna/fasta)
├── SRR28703325.seqkit.mini.txt --> seqkit stats (txt file)
├── SRR28703325_1.clean.mini.fastq.gz --> fastp outputs (fastq.gz)
└── SRR28703325_2.clean.mini.fastq.gz 

