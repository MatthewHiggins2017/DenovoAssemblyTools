#!/usr/bin/env nextflow

/*

################
# Description  #
################

Run FLYE Assembly

################
# Test Command #
################

nextflow ./NF/modules/ContigAssembly.nf --ID TestQC --Fastq ~/Documents/Work/Github/Research/DenovoAssemblyTools/Examples/RawData/Test.fastq --Threads 3 --ReadError 0.20 --PackagePath /home/matt_h/Downloads



*/



/* ########################
    DEFINE PARAMETERS 
############################ */

// General Parameters
params.ID = "Test"
params.Fastq = "default"
params.Threads = 2
params.Outdir = "./TestRun"
params.PackagePath = "~/DenovoAssemblyTools/"

// Flye Parameters
params.ReadError = 0.06

/* ########################
    DEFINE WORKFLOWS 
############################ */

workflow ContigAssembly {

    take:
    ID
    Fastq
    Threads
    ReadError
    PackagePath

    main:
    Flye(ID,
         Fastq,
         Threads,
         ReadError,
         PackagePath)
}


// DEFAULT WORKFLOW
workflow {
    ContigAssembly(params.ID,
                   params.Fastq,
                   params.Threads,
                   params.ReadError,
                   params.PackagePath)
}

process Flye {

    // Define path to container
    container "${PackagePath}/Containers/FLYE.sif"

    // Defines where output files will be stored on process completion
    publishDir "${params.Outdir}/02_ContigAssemby"

    // Input variables required
    input:
    val(ID)
    val(reads)
    val(threads)
    val(ErrorProb)
    val(PackagePath)

    // Output variable which is expected and checked for.
    output:
    path "${ID}_Flye_Assembly/assembly.fasta"

    // Run Script
    script:
    """
    flye --nano-hq ${reads} \
    -t ${threads} \
    --read-error ${ErrorProb} \
    -o ${ID}_Flye_Assembly
    """

}