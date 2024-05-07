#!/usr/bin/env nextflow

/*

nextflow Scripts/ContigAssembly.nf --ID TestQC --Fastq ~/Documents/Work/Github/Research/DenovoAssemblyTools/Examples/RawData/Test.fastq --Threads 3 --ReadError 0.20

*/

// General Parameters
params.ID = "Test"
params.Fastq = "default"
params.Threads = 2
params.Outdir = "./TestRun"

// Flye Parameters
params.ReadError = 0.06


workflow {
    Flye(params.ID,
         params.Fastq,
         params.Threads,
         params.ReadError)
}

process Flye {

    // Define path to container
    container '/home/matt_h/Downloads/FLYE.sif'

    // Defines where output files will be stored on process completion
    publishDir "${params.Outdir}/02_ContigAssemby"

    // Input variables required
    input:
    val(ID)
    val(reads)
    val(threads)
    val(ErrorProb)

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