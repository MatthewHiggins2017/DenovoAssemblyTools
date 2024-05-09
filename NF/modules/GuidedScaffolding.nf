#!/usr/bin/env nextflow

/*

################
# Description  #
################

Run Guided Scaffolding

################
# Test Command #
################


nextflow ./NF/modules/GuidedScaffolding.nf --ID TestQC --GuideReference ~/Documents/Work/Github/Research/DenovoAssemblyTools/Examples/RawData/reference.fasta --Assembly ~/Documents/Work/Github/Research/DenovoAssemblyTools/Examples/RawData/assembly.fasta --Outdir ./TestRun --PackagePath /home/matt_h/Downloads

*/


/* ########################
    DEFINE PARAMETERS 
############################ */


// General Parameters
params.ID = "Test"
params.Outdir = "./TestRun"
params.Assembly = "default"
params.GuideReference = "default"
params.Threads = 2
params.PackagePath = "~/DenovoAssemblyTools/"



/* ########################
    DEFINE WORKFLOWS 
############################ */


workflow GuidedScaffolding {
    take:
    ID
    GuideReference
    Assembly
    Threads
    PackagePath

    main:
    RagTag(ID,
            GuideReference,
            Assembly,
            Threads,
            PackagePath)

    emit:
    RagTag.out
}



// Default Workflow
workflow {
    GuidedScaffolding(params.ID,
            params.GuideReference,
            params.Assembly,
            params.Threads,
            params.PackagePath)
}


/* ########################
    DEFINE PROCESS 
############################ */


process RagTag {

    // Define path to container
    container "${PackagePath}/Containers/RagTag.sif"


    // Defines where output files will be stored on process completion
    publishDir "${params.Outdir}/05_GuidedScaffolding"

    // Input variables required
    input:
    val(ID)
    val(GuideReference)
    val(assembly)
    val(threads)
    val(PackagePath)


    // Output variable which is expected and checked for.
    output:
    file "${ID}_Guided_Scaffolding/ragtag.scaffold.fasta"

    // Run Script
    script:
    """
    ragtag.py scaffold ${GuideReference} ${assembly} -o ${ID}_Guided_Scaffolding --mm2-params '-x asm20 -t ${threads}'
    """

}

