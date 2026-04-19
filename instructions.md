# Workflow Exercise

## Specific Learning Objectives

1. Identify how workflow languages handle complex tasks, such as data dependencies, resource management, and parallel execution, essential for building scalable and reproducible workflows.

1. Learn how reproducibility in workflows is achieved through version control, environment specification (e.g., containers), and modular execution in workflow languages.

1. Understand how to invoke, configure, and manage external tools within a workflow to create a coherent, fully integrated genomics pipeline.

1. Learn the built-in error handling features of workflow languages, enabling efficient troubleshooting and improving the robustness of computational pipelines.

1. Gain hands-on experience in packaging genomics tools in Nextflow modules and running them in a portable and reproducible manner across different environments.

1. Learn to define tasks in Nextflow and link them using input/output channels to ensure proper sequential flow.

1. Gain proficiency in using Nextflow's ability to fork processes, handle parallelism, and merge results efficiently.


## Objective

- Your main objective here is to create a nextflow workflow that uses software relevant to computational genomics and is fully contained and operational on a laptop running Linux, MacOS, or WSL2.

- The workflow must have both features:
    - **sequential processing**:  where output of one step (in a nextflow "module") gets passed onto the next
    - **parallel processing**:  where two independent "modules" (tasks) are done at the same time

        ```
        Workflow Overview:
        -------------------
        Sequential (1 to 2 and 2 to 3):
        +--------------------+     +--------------------+
        | Module 1           | ---> | Module 2           |
        +--------------------+     +--------------------+
                                        |
                                        v
                                    +--------------------+
                                    | Module 3           |
                                    +--------------------+

        Parallel (2 & 3 simultaneously done):
                        +--------------------+     +--------------------+
                        | Module 1           | ---> | Module 2           |
                        +--------------------+     +--------------------+
                                        |
                                        v
                        +--------------------+
                        | Module 3           |
                        +--------------------+ 
        ```

## Additional Expectations

- If this is for professional development, can I use a public github repo instead of internal GATech?
    - **Yes!** You can use a public github account, as long as the username clearly matches to you, you explicitly list in the README it's for BIOL7210, and all commit activity corresponds to your user with appropriate timeline.

- Which software tools are acceptable?
    - They must be **genomics**-related tools, so when in doubt ask. The course has been on bacterial genomics, so certainly any tools you've used in the class are acceptable. You might be more interested in viral or eukaryotic genomics, and those are fine tools to use as well, especially if it would help you in other tasks as a graduate student.

- So I have in mind tools, how should I handle the install of each?
    - So far in the course, you've been introduced to conda and docker. You're welcome to choose one of those, and conda is likely to be the easiest (e.g., requiring a user to specify `-profile conda` like [this](https://www.nextflow.io/docs/latest/conda.html#best-practices)). You're also welcome to use another package manager supported by nextflow, such as apptainer, especially if your research team uses it. Regardless of choice, the workflow itself must handle the installation and use of the software. In other words, you cannot ask a user to conda install all the tool dependencies prior to running it.

- How about the nextflow language itself, how should that be controlled?
    - Have a simple conda env with nextflow and nothing else in it. Running `conda create -n nf -c bioconda nextflow -y` to create your dev env is all you need to do to make it. Explicitly mentioning the nextflow version you use needs to be added to the README.md, so I know quickly which to have for testing. Currently `nextflow -version` shows v24.10.5 for me, but as long as you explicitly state the version, even if it's an older one, I will set that up prior to testing.

- What info is required for the package manager itself, such as conda, docker, or apptainer?
    - Simply listing that as a dependency as version number is sufficient (similar to the nextflow language version itself).

- Is this a group, team, or individual exercise?
    - Grades will be assigned on an individual student basis, but I encourage you to work with classmates and share tips and tricks along the way.

- What data are required for the workflow?
    - The repo itself must contain a small (quick runtime) test dataset. One way to handle it, is simply having a subdir containing the files and in your README including that in your commands to run as a test. Another option is to setup as a dedicated profile like [this](https://training.nextflow.io/latest/hello_nextflow/06_hello_config/#43-create-a-test-profile), so a user can simply run `-profile test,conda` to invoke the test data using conda for example. A third option you'll see advanced nextflow workflows use sometimes is a samplesheet.csv file containing URLs that automatically fetch data, but I wouldn't recommend that for this exercise unless you're already experienced with those methods due to its complexity. One trick, if using FastQ as input, to generate a quick "mini" test set is simply `zcat <FASTQ.GZ> | head -n 4000 > mini.fastq.gz` If your initial input is an assembly file, look for something small but still reasonable to test functionality.

- Can I use class from a previous component in the class for test data?
    - No. Please use something different. For FastQ, you could fetch data from [SRA](https://www.ncbi.nlm.nih.gov/sra) and generate a mini set on your own to include within your repo, use direct URLs from searching [EBI](https://www.ebi.ac.uk/), or even a samplesheet like [this](https://raw.githubusercontent.com/bacterial-genomics/test-datasets/assembly/samplesheets/samplesheet.csv). For FastA, GBK, or GFF test input, I would use a file already available in NCBI's [RefSeq](https://www.ncbi.nlm.nih.gov/refseq/). Those are just 4 examples, but you're welcome to use anything relevant to your workflow as long as it's not from previous content in this course.

- Can I have the test run on an HPC?
    - No. Nextflow calls these different ["executors"](https://www.nextflow.io/docs/latest/executor.html) to allow a user to swap between HPC Job Schedulers, Cloud, k8s, etc., but for me to test, it must be **local** by default. You're welcome to expand later to your own infrastructure such as SLURM to support `sbatch` [here](https://www.nextflow.io/docs/latest/executor.html#slurm) after the assignment is graded.

- I'm lost and just need guidance which tools to do this, any advice?
    - **Yes!** You can _combine_ sequential and parallel requirements with as little as three modules:
            1. From raw FastQ, run `fastp` on it ("Module 1")
            2. Output from `fastp` then used to run `spades` (for assembly, "Module 2"), and output from `fastp` also used to run `seqkit` (for read metrics, "Module 3") at the same time (in parallel)

## Tips for Success

- **Learn about Channels**: Channels are the main mechanism for managing data flow between processes in Nextflow. When you want processes to run in parallel, you typically pass the data through a channel, and multiple processes can consume that channel independently.
    - Nextflow automatically runs tasks in _parallel_ if their inputs are **independent**.
    - Nextflow automatically runs tasks in _sequential_ order if their inputs/outputs are **dependent**.

- **Start Small:** Begin with a simple pipeline, focusing on one task at a time. This helps you familiarize yourself with Nextflow's syntax and debugging techniques without being overwhelmed.

- **Use `nf-core` Tools** to avoid struggling with too much creation syntax. It is best installed as its own conda env [here](https://nf-co.re/docs/nf-core-tools/installation). You can create the initial workflow framework with [this](https://nf-co.re/docs/nf-core-tools/pipelines/create) and add in individual modules afterwards with [this](https://nf-co.re/docs/nf-core-tools/modules/install). Note for modules the `create` is to develop a _new_ module that doesn't exist in nf-core yet. That isn't necessary for this exercise, although you might find [its documentation](https://nf-co.re/docs/nf-core-tools/modules/create) useful if your own research later on requires a tool not yet in there.

- **Use `git` Commits** after each step to avoid having to start over. Re-writing a single `bash` pipeline is tough and time-consuming, but re-writing a workflow from scratch is _much_ more frustrating!

- **Be Aware of Script vs Shell in Nextflow Modules:** Be consistent throughout your first workflow and just choose one or the other. The syntax inside each are different in how you use nextflow and bash variables.
    - _script_:  nextflow variable = `${var}` whereas bash variable = `\${var}`
    - _shell_:  nextflow variable = `!var` whereas bash variable = `${var}`

- **Avoid Over-Engineering** and harcoding variables such as `--cpus 16`

- [**The special `meta` variable:**](https://nf-co.re/docs/contributing/components/meta_map) in nf-core modules within DSL2 of Nextflow is a key feature that holds metadata for the module, which is used to describe the task or process in the pipeline. This metadata can be used for documentation, pipeline configuration, and managing inputs/outputs for different types of data. For example, you can access with !{meta.id} or ${meta.id} depending on whether you're using script or shell.
    - _meta.id_: the unique identifier for the process
    - _meta.name_: a human-readable name for the process
    - *meta.single_end*: specifies that the input is single-end data
    - *meta.paired_end*: specifies that the input is paired-end data
    - _meta.description_: provides a description of the process
    - _meta.version_: specifies the version of the process/tool

- **Learn Key Nextflow Debugging:**
    - `nextflow log`: view the execution log for detailed task and process outputs to diagnose issues.
    - `-resume`: resume a pipeline from the last successful run, which is useful for recovering from failures (skipping a successful first step's compute time, for example)
    - `-d` (debug mode): run Nextflow in debug mode to get additional output for troubleshooting
    - `nextflow trace`: trace the pipeline execution to visualize task timing, duration, and resource usage
    - `nextflow validate`: check syntax and structure of the workflow for potential issues _before_ execution

- **Check Task Outputs:** Always ensure that outputs of each task are being correctly passed to the next step (e.g., using channel syntax for data flow). Print statements can help with this.

- **Use `println` for Debugging:** Insert `println` statements in your process scripts to output debugging information directly to the console during execution. This helps track data flow and task execution.

- **Monitor Performance:** Use the `-with-timeline` option to visualize task execution times and resource usage, allowing you to identify slow or resource-heavy steps and optimize them. If something is taking >10 min, adjust input or parameters to speed it up.

- **A direct acyclic graph (DAG) image** can be automatically created for you with [this](https://www.nextflow.io/docs/latest/reports.html#workflow-diagram), and you should look at it to **verify** your modules are operating in both **sequential** and **parallel** order to satisfy the overall objective. For your README, however, you might find it easy to generate your own as well with free cross-platform tools like [InkScape](https://inkscape.org/).

## Resources

- [**_VS Code Nextflow Extension:_**](https://github.com/nextflow-io/vscode-language-nextflow): provides syntax highlighting for .nf files in Visual Studio Code, making it easier to read and write Nextflow

- [**_nextflow:_**](https://www.nextflow.io/) official homepage for the language itself

- [**_nf-core:_**](https://nf-co.re/) a community of high-quality modules and workflows. Their docs also have resources for learning how to build, [lint](https://nf-co.re/docs/nf-core-tools/pipelines/lint), and modify Nextflow workflows.

- [**Nextflow DSL2 Cheat Sheet:**](https://github.com/danrlu/Nextflow_cheatsheet/blob/main/nextflow_cheatsheet.pdf) a concise cheat sheet for quickly referencing DSL2 syntax and structure

- [**Nextflow Documentation (Official):**](https://www.nextflow.io/docs/) a comprehensive guide to understanding Nextflow syntax, features, and advanced usage

- [**Nextflow YouTube Channel:**](https://www.youtube.com/c/Nextflow) official YouTube channel with video tutorials and walkthroughs

- [**Nextflow Training:**](https://training.nextflow.io/latest/) structured online courses from the creators of Nextflow that help users get started with writing pipelines

 - [**Basic training:**](https://training.nextflow.io/latest/basic_training/#follow-the-training-videos-and-get-help) in many different languages
    - [English](https://youtube.com/playlist?list=PL3xpfTVZLcNhoWxHR0CS-7xzu5eRT8uHo) 
    - [Hindi](https://youtube.com/playlist?list=PL3xpfTVZLcNikun1FrSvtXW8ic32TciTJ)
    - [Spanish](https://youtube.com/playlist?list=PL3xpfTVZLcNhSlCWVoa3GURacuLWeFc8O)
    - [Portuguese](https://youtube.com/playlist?list=PL3xpfTVZLcNhi41yDYhyHitUhIcUHIbJg)
    - [French](https://youtube.com/playlist?list=PL3xpfTVZLcNhiv9SjhoA1EDOXj9nzIqdS)



## Homework Assignment

1. submit the repo URL (gunzip compressed TXT file, named "my-wf-repo.txt.gz") to Canvas containing a single line that I can directly clone with SSH after (e.g., `git@github.gatech.edu:cgulvik/my_first_wf.git`)
    - similar to first exercise [here](https://github.gatech.edu/compgenomics2025/Exercises/blob/main/GitHub/README.md)



## Homework Grade Distribution

1. **Data for testing (1 Point)**
    - **[1]** Test data contained in the repo and location clearly described in the README
    - **[0]** Test data are missing

1. **Requirements (1 Point)**

    - **[1]** Nextflow version, package manager & version, OS, and architecture used all listed in README.
    - **[0]** Incomplete listing

1. **Workflow Diagram (1 Point)**

    - **[1]** Illustration image (e.g., PNG) embedded and illustrates the steps performed in the workflow
    - **[0]** Image missing

1. **Workflow Test (2 Points)**

    - **[2]** 3 or less commands in the README copy/paste ran, after installation requirements satisfied, allow for successful completion of both sequential and parallel tasks on a laptop in < 30 min.
    - **[0]** Incomplete listing