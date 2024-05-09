#!/usr/bin/env nextflow

/*

################
# Description  #
################

Close gaps in asssembly

################
# Test Command #
################

nextflow ./NF/modules/GapClosing.nf --ID TestQC --Fastq ~/Documents/Work/Github/Research/DenovoAssemblyTools/Examples/RawData/Test.fastq --Assembly ~/Documents/Work/Github/Research/DenovoAssemblyTools/Examples/RawData/reference.fasta --PackagePath /home/matt_h/Downloads


*/


/* ########################
    DEFINE PARAMETERS 
############################ */

// General Parameters
params.ID = "Test"
params.Assembly = "default"
params.Fastq = "default"
params.Threads = 2
params.Outdir = "./TestRun"
params.PackagePath = "~/DenovoAssemblyTools/"


// TGSGapCloser Parameters


/* ########################
    DEFINE WORKFLOWS 
############################ */

workflow GapCloser {
    take:
    ID
    Fastq
    Assembly
    Threads
    PackagePath

    main:
    TGSGapCloser(ID,
                Fastq,
                Assembly,
                Threads,
                PackagePath)

    emit:
    TGSGapCloser.out

}


// Default Workflow
workflow {
    GapCloser(params.ID,
                params.Fastq,
                params.Assembly,
                params.Threads,
                params.PackagePath)
}


/* ########################
    DEFINE PROCESS 
############################ */

process TGSGapCloser {

    // Define path to container
    container "${PackagePath}/Containers/TGSGapCloser.sif"


    // Defines where output files will be stored on process completion
    publishDir "${params.Outdir}/06_GapClosing"

    // Input variables required
    input:
    val(ID)
    val(fastq)
    val(assembly)
    val(threads)
    val(PackagePath)


    // Output variable which is expected and checked for.
    output:
    file "${ID}_TGS_GapClosing.scaff_seqs"

    // Run Script
    script:
    """
    tgsgapcloser --scaff ${assembly} \
    --reads ${fastq} \
    --output ${ID}_TGS_GapClosing \
    --threads ${threads} --ne 
    """
}