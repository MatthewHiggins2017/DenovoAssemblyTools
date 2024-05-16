#!/usr/bin/env nextflow

/*

nextflow ./NF/modules/AssemblyAssessment.nf --ID TestQC --Assembly ~/Documents/Work/Github/Research/DenovoAssemblyTools/Examples/RawData/Busco_Test.fa --Threads 2 --Outdir ./TestRun --PackagePath /home/matt_h/Documents/Work/Github/Research/DenovoAssemblyTools

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


// BUSCO Parameters
params.BuscoDatabase = 'eukaryota_odb10'

/* ########################
    DEFINE WORKFLOWS 
############################ */

workflow AssemblyAssessment {
    take:
    ID
    Assembly
    Threads
    BuscoDatabase
    PackagePath

    main:
    Busco(ID,
          Assembly,
          Threads,
          BuscoDatabase,
          PackagePath)

    emit:
    Busco.out
}


// Default Workflow
workflow {
    
    Busco(params.ID,
            params.Assembly,
            params.Threads,
            params.BuscoDatabase,
            params.PackagePath)
}

/* ########################
    DEFINE PROCESS 
############################ */


process Busco {

    // Define path to container
    container "${PackagePath}/Containers/BUSCO.sif"

    // Defines where output files will be stored on process completion
    publishDir "${params.Outdir}/00_Assesment"

    // Input variables required
    input:
    val(ID)
    val(assembly)
    val(threads)
    val(buscodatabase)
    val(PackagePath)


    // Output variable which is expected and checked for.
    output:
    path "${ID}_BUSCO_Assessment/short_summary.specific.${buscodatabase}.${ID}_BUSCO_Assessment.txt"

    // Run Script
    script:
    """
    busco -m genome -i ${assembly}  -l ${buscodatabase} -o ${ID}_BUSCO_Assessment -c ${threads}

    """

}
