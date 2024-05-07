#!/usr/bin/env nextflow

/*

nextflow Scripts/AssemblyPolishing.nf --ID TestQC --Fastq ~/Documents/Work/Github/Research/DenovoAssemblyTools/Examples/RawData/Test.fastq --Assembly ~/Documents/Work/Github/Research/DenovoAssemblyTools/Examples/RawData/reference.fasta

*/


// General Parameters
params.ID = "Test"
params.Assembly = "default"
params.Fastq = "default"
params.Threads = 2
params.Outdir = "./TestRun"




workflow {

    Racon(params.ID,
         params.Fastq,
         params.Assembly,
         params.Threads)
}

process Racon {

    // Define path to container
    container '/home/matt_h/Downloads/Racon.sif'

    // Defines where output files will be stored on process completion
    publishDir "${params.Outdir}/07_AssemblyPolishing"

    // Input variables required
    input:
    val(ID)
    val(reads)
    val(assembly)
    val(threads)


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