#!/usr/bin/env nextflow

/*

nextflow QualityControl/RawDataQC.nf --ID TestQC --Fastq ~/Documents/Work/Github/Research/DenovoAssemblyTools/Examples/RawData/Test.fastq --Threads 2 --KrakenReport ~/Documents/Work/Github/Research/DenovoAssemblyTools/Examples/RawData/Test.report --KrakenOutput ~/Documents/Work/Github/Research/DenovoAssemblyTools/Examples/RawData/Test.kraken --ExcludeTaxID 2 --Outdir ./TestRun

*/


// General Parameters
params.ID = "Test"
params.Fastq = "default"
params.Threads = 2
params.Outdir = "default"

// Kraken Decontamination Parameters
params.KrakenReport = "default"
params.KrakenOutput = "default"
params.ExcludeTaxID = "TaxIDs"


// Filtering Parameters
params.MinLength = 1000
params.MinQuality = 7

workflow {
    
    KrakenFilt(params.ID,
               params.Fastq,
               params.KrakenReport,
               params.KrakenOutput,
               params.ExcludeTaxID)
    
    Scrub(params.ID, 
          KrakenFilt.out, 
          params.Threads)

    QualFilter( params.ID,
                Scrub.out,
                params.Threads,
                params.MinLength,
                params.MinQuality)
    }




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