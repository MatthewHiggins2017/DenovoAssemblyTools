#!/usr/bin/env nextflow

/*


################
# Description  #
################

Remove contamination

################
# Test Command #
################

NEED TO TEST THIS! 

Tool:

https://github.com/ncbi/fcs/wiki/FCS-GX-quickstart


*/


/* ########################
    DEFINE PARAMETERS 
############################ */

// General Parameters
params.ID = "Test"
params.Assembly = "default"
params.Threads = 2
params.Outdir = "./TestRun"
params.PackagePath = "~/DenovoAssemblyTools/"


// FCS-GX Parameters
params.SampleTaxID = '1'

/* ########################
    DEFINE WORKFLOWS 
############################ */


Workflow FCSRun {

    take:
    ID
    Assembly
    Threads
    SampleTaxID
    GxDatabase
    PackagePath

    main:
    FcsGX(ID,
          Assembly,
          Threads,
          SampleTaxID,
          GxDatabase,
          PackagePath)

    emit:
    FcsGX.emit
}



// Defualt Workflow
Workflow {

    FcsGX(params.ID,
          params.Assembly,
          params.Threads,
          params.SampleTaxID,
          params.GxDatabase,
          params.PackagePath)
}


process FcsGX {

    // Define path to container
    container "${PackagePath}/Containers/FcsGX.sif"


    // Defines where output files will be stored on process completion
    publishDir "${params.Outdir}/03_FCS"

    // Input variables required
    input:
    val(ID)
    val(assembly)
    val(threads)
    val(taxid)
    val(GxDatabase)
    val(PackagePath)

    // Output variable which is expected and checked for.
    output:
    path "${ID}_FCS_Out/${ID}_Decontaminated.fasta"

    // Run Script
    script:
    """
    python3 fcs.py screen genome \
    --fasta ${assembly} \
    --out-dir ${ID}_FCS_Out \
    --gx-db  ${GxDatabase} \
    --tax-id ${taxid} ; 

    cat ${assembly} | python3 fcs.py clean genome \ 
    --action-report ${ID}_FCS_Out/${assembly%.*}.${taxid}.fcs_gx_report.txt \
    --output ${ID}_FCS_Out/${ID}_Decontaminated.fasta \
    --contam-fasta-out ${ID}_FCS_Out/Contamination.fasta


    """

}