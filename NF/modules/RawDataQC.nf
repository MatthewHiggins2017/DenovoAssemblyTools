#!/usr/bin/env nextflow

/*


################
# Test Command #
################

nextflow ./NF/modules/RawDataQC.nf --ID Test --Fastq ~/Documents/Work/Github/Research/DenovoAssemblyTools/Examples/RawData/Test.fastq --Threads 2 --KrakenReport ~/Documents/Work/Github/Research/DenovoAssemblyTools/Examples/RawData/Test.report --KrakenOutput ~/Documents/Work/Github/Research/DenovoAssemblyTools/Examples/RawData/Test.kraken --ExcludeTaxID 2 --Outdir ./TestRun

*/


/* ########################
    DEFINE PARAMETERS 
############################ */

// General Parameters
params.ID = "Test"
params.Fastq = "default"
params.Threads = 2
params.Outdir = "./TestRun"

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

    // Use take to define input 
    take: 
    ID
    Fastq
    KrakenReport
    KrakenOutput
    ExcludeTaxID
    Threads
    MinLength
    MinQuality
    
    main:
    KrakenFilt(ID,
               Fastq,
               KrakenReport,
               KrakenOutput,
               ExcludeTaxID)
    

    Scrub(ID, 
          KrakenFilt.out, 
          Threads)


    QualFilter(ID,
               Scrub.out,
               Threads,
               MinLength,
               MinQuality)
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
            params.MinQuality)
}


/* ########################
    DEFINE PROCESSESS 
############################ */


process KrakenFilt {

    // Define path to container
    container '/home/matt_h/Downloads/KRAKENTOOLS.sif'

    // Defines where output files will be stored on process completion
    publishDir "${params.Outdir}/DataQC/01_Decontamination"

    // Input variables required
    input:
    val(ID)
    val(reads)
    val(KrakenReport)
    val(KrakenOutput)
    val(TaxIDs)

    // Output variable which is expected and checked for.
    output:
    path "${ID}.KrakFilt.fastq"

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
    container '/home/matt_h/Downloads/YACRD.sif'

    // Defines where output files will be stored on process completion
    publishDir "${params.Outdir}/DataQC/02_Scrubbing"

    // Input variables required
    input:
    val(ID)
    val(reads)
    val(threads)

    // Output variable which is expected and checked for.
    output:
    path "${ID}.Yacrd.fastq"

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

    container '/home/matt_h/Downloads/CHOPPER.sif'

    // Defines where output files will be stored on process completion
    publishDir "${params.Outdir}/DataQC/03_Filtered"

    // Input variables required
    input:
    val(ID)
    val(reads)
    val(Threads)
    val(MinLength)
    val(MinQuality)

    // Output variable which is expected and checked for.
    output:
    path "${ID}.QualFilt.fastq"

    // Run Script
    script:
    """
    
    cat ${reads} | chopper -t ${Threads} -l ${MinLength} -q ${MinQuality} > ${ID}.QualFilt.fastq

    """

}