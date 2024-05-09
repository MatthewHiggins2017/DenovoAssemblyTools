#!/usr/bin/env nextflow

/*

Example Command:

nextflow ./NF/main.nf --ID MainTest --Fastq ~/Documents/Work/Github/Research/DenovoAssemblyTools/Examples/RawData/Test.fastq --Threads 2 --KrakenReport ~/Documents/Work/Github/Research/DenovoAssemblyTools/Examples/RawData/Test.report --KrakenOutput ~/Documents/Work/Github/Research/DenovoAssemblyTools/Examples/RawData/Test.kraken --ExcludeTaxID 562 --Outdir ./MainTest

Background:

This is the wrapper script for the full de novo assembly pipeline. 

1) RawDataQC
2) ContigAssembly
3) ForeignContaminationScreen
4) UnguidedScaffolding
5) GuidedScaffolding
6) GapClosing
7) AssemblyPolishing

*/


/* ##################################
    # Define the pipeline parameters #
#################################### */

// General Parameters
params.ID = "Test"
params.Fastq = "default"
params.Threads = 2
params.Outdir = "./TestRun"

// Kraken Decontamination Parameters
params.KrakenReport = "default"
params.KrakenOutput = "default"
params.ExcludeTaxID = "TaxIDs"

// Chopper Filtering Parameters
params.MinLength = 1000
params.MinQuality = 7

// Flye Parameters
params.ReadError = 0.06


/* ##################################
    # Import necessary workflows    #
##################################### */


include { DataQC  } from './modules/RawDataQC.nf'
include { ContigAssembly  } from './modules/ContigAssembly.nf'



// Define default workflow
workflow {

    // Filter Raw Data
    DataQC(params.ID,
           params.Fastq,
           params.KrakenReport,
           params.KrakenOutput,
           params.ExcludeTaxID,
           params.Threads,
           params.MinLength,
           params.MinQuality)

    // Run Contig Data.
    // Figure out how to parse the output of DataQC
    ContigAssembly(params.ID,
                    DataQC.out,
                    params.Threads,
                    params.ReadError)


}

