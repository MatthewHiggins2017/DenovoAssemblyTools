#!/usr/bin/env nextflow

/*

################
# Description  #
################

Prepare Minion data for De Novo Assembly.

################
# Test Command #
################

nextflow ./NF/modules/RawDataQC.nf --ID Test --Fastq ~/Documents/Work/Github/Research/DenovoAssemblyTools/Examples/RawData/Test.fastq --Threads 2 --KrakenReport ~/Documents/Work/Github/Research/DenovoAssemblyTools/Examples/RawData/Test.report --KrakenOutput ~/Documents/Work/Github/Research/DenovoAssemblyTools/Examples/RawData/Test.kraken --ExcludeTaxID 2 --Outdir ./TestRun --PackagePath /home/matt_h/Documents/Work/Github/Research/DenovoAssemblyTools

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

// Kraken Decontamination Parameters
params.KrakenReport = "default"
params.KrakenOutput = "default"
params.ExcludeTaxID = "TaxIDs"


// Filtering Parameters
params.MinLength = 1000
params.MinQuality = 7


/* ########################
    DEFINE WORKFLOWS 
############################ */


// Define Workflow DataQC
workflow DataQC {

    // Use take: to define workflow inputs 
    take: 
    ID
    Fastq
    KrakenReport
    KrakenOutput
    ExcludeTaxID
    Threads
    MinLength
    MinQuality
    PackagePath
    
    // Use main: to define workflow processes.
    main:
    KrakenFilt(ID,
               Fastq,
               KrakenReport,
               KrakenOutput,
               ExcludeTaxID,
               PackagePath)
    

    Scrub(ID, 
          KrakenFilt.out, 
          Threads,
          PackagePath)


    QualFilter(ID,
               Scrub.out,
               Threads,
               MinLength,
               MinQuality,
               PackagePath)

    // Define what is the output (emitted) from the workflow
    emit:
    QualFilter.out
    
    }


// DEFAULT WORKFLOW
// This will be run when the script is executed. So it can be used as standalone.
workflow {

    DataQC(params.ID, 
           params.Fastq,
           params.KrakenReport,
            params.KrakenOutput,
            params.ExcludeTaxID,
            params.Threads,
            params.MinLength,
            params.MinQuality,
            params.PackagePath)
}


/* ########################
    DEFINE PROCESSESS 
############################ */


process KrakenFilt {

    // Define path to container 
    container "${PackagePath}/Containers/KRAKENTOOLS.sif"

    // Defines where output files will be stored on process completion
    publishDir "${params.Outdir}/DataQC/Decontamination"

    // Input variables required
    input:
    val(ID)
    val(reads)
    val(KrakenReport)
    val(KrakenOutput)
    val(TaxIDs)
    val(PackagePath)

    // Output variable which is expected and checked for.
    output:
    file "${ID}.KrakFilt.fastq"

    // Run Script
    script:
    """
    
    extract_kraken_reads.py -k ${KrakenOutput} \
                            -r ${KrakenReport} \
                            -s ${reads} \
                            -o ${ID}.KrakFilt.fastq \
                            --taxid ${TaxIDs} \
                            --exclude \
                            --include-children \
                            --fastq-output

    """

}



process Scrub {

    // Defines path to singularity container
    container "${PackagePath}/Containers/YACRD.sif"

    // Defines where output files will be stored on process completion
    publishDir "${params.Outdir}/DataQC/02_Scrubbing"

    // Input variables required
    input:
    val(ID)
    val(reads)
    val(threads)
    val(PackagePath)

    // Output variable which is expected and checked for.
    output:
    file "${ID}.Yacrd.fastq"

    // Run Script
    script:
    """

    minimap2 -x map-ont  \
              -t ${threads} \
              ${reads} \
              ${reads}  >  ${ID}.YCARD.paf ; 
    yacrd   -i  ${ID}.YCARD.paf \
            -o  ${ID}.yacrd.report \
            -c 4 -n 0.4 scrubb \
            -i  ${reads}  \
            -o  ${ID}.Yacrd.fastq
            
    """

}


process QualFilter {

    container "${PackagePath}/Containers/CHOPPER.sif"

    // Defines where output files will be stored on process completion
    publishDir "${params.Outdir}/DataQC/03_Filtered"

    // Input variables required
    input:
    val(ID)
    val(reads)
    val(Threads)
    val(MinLength)
    val(MinQuality)
    val(PackagePath)

    // Output variable which is expected and checked for.
    output:
    file "${ID}.QualFilt.fastq" 

    // Run Script
    script:
    """
    
    cat ${reads} | chopper -t ${Threads} -l ${MinLength} -q ${MinQuality} > ${ID}.QualFilt.fastq

    """

}