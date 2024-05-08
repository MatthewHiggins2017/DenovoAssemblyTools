#!/usr/bin/env nextflow

/*

nextflow Scripts/GapClosing.nf --ID TestQC --Fastq ~/Documents/Work/Github/Research/DenovoAssemblyTools/Examples/RawData/Test.fastq --Assembly ~/Documents/Work/Github/Research/DenovoAssemblyTools/Examples/RawData/reference.fasta


*/

// General Parameters
params.ID = "Test"
params.Assembly = "default"
params.Fastq = "default"
params.Threads = 2
params.Outdir = "./TestRun"

// TGSGapCloser Parameters



workflow {
    TGSGapCloser(params.ID,
                params.Fastq,
                params.Assembly,
                params.Threads)
}

process TGSGapCloser {

    // Define path to container
    container '/home/matt_h/Downloads/TGSGapCloser.sif'

    // Defines where output files will be stored on process completion
    publishDir "${params.Outdir}/06_GapClosing"

    // Input variables required
    input:
    val(ID)
    val(fastq)
    val(assembly)
    val(threads)


    // Output variable which is expected and checked for.
    output:
    path "${ID}_TGS_GapClosing.scaff_seqs"

    // Run Script
    script:
    """
    tgsgapcloser --scaff ${assembly} \
    --reads ${fastq} \
    --output ${ID}_TGS_GapClosing \
    --threads ${threads} --ne 
    """
}