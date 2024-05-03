#!/usr/bin/env nextflow

params.ID = 'default_ID'
params.Fastq = "default_value"
params.Threads = "default_threads"
params.Outdir = "default_outdir"


workflow {
    Scrub(params.ID, params.Fastq, params.Threads)
    }


process Scrub {

    // Defines where output files will be stored on process completion
    publishDir "${params.outdir}/DataQC"

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