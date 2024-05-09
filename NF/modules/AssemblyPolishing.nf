#!/usr/bin/env nextflow

/*

################
# Description  #
################

Run Assembly Polishing

################
# Test Command #
################


nextflow ./NF/modules/AssemblyPolishing.nf --ID TestQC --Fastq ~/Documents/Work/Github/Research/DenovoAssemblyTools/Examples/RawData/Test.fastq --Assembly ~/Documents/Work/Github/Research/DenovoAssemblyTools/Examples/RawData/reference.fasta --PackagePath /home/matt_h/Downloads

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



/* ########################
    DEFINE WORKFLOWS 
############################ */

workflow Polish {

    take:
    ID
    Fastq
    Assembly
    Threads
    PackagePath


    main:
    Racon(ID,
         Fastq,
         Assembly,
         Threads,
         PackagePath)

    emit:
    Racon.out
}


// Defualt Workflow
workflow {

    Racon(params.ID,
         params.Fastq,
         params.Assembly,
         params.Threads,
         params.PackagePath)
}


/* ########################
    DEFINE PROCESS 
############################ */


process Racon {

    // Define path to container
    container "${PackagePath}/Containers/Racon.sif"


    // Defines where output files will be stored on process completion
    publishDir "${params.Outdir}/07_AssemblyPolishing"

    // Input variables required
    input:
    val(ID)
    val(reads)
    val(assembly)
    val(threads)
    val(PackagePath)


    // Output variable which is expected and checked for.
    output:
    path "${ID}_Racon_Polished.fasta"

    // Run Script
    script:
    """
    minimap2 -t ${threads} -x map-ont ${assembly} ${reads} > ${ID}_Racon.paf ; \
    racon -u --no-trimming ${reads} ${ID}_Racon.paf ${assembly} > ${ID}_Racon_Polished.fasta

    """
}