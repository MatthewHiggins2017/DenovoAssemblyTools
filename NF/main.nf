#!/usr/bin/env nextflow

/*

Example Command:

nextflow ./NF/main.nf --ID MainTest --Fastq ~/Documents/Work/Github/Research/DenovoAssemblyTools/Examples/RawData/Test.fastq --Threads 2 --KrakenReport ~/Documents/Work/Github/Research/DenovoAssemblyTools/Examples/RawData/Test.report --KrakenOutput ~/Documents/Work/Github/Research/DenovoAssemblyTools/Examples/RawData/Test.kraken --ExcludeTaxID 562 --Outdir ./MainTest --PackagePath /home/matt_h/Documents/Work/Github/Research/DenovoAssemblyTools


EXPAND TEST COMMAND AND VALIDATE ON LARGER INPUT DATASET. 

*/


/* ##################################
    # Define the pipeline parameters #
#################################### */

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

// Chopper Filtering Parameters
params.MinLength = 1000
params.MinQuality = 7

// Flye Parameters
params.ReadError = 0.06

// NtLink Parameters
params.NtLinkRounds = 3

// RagTag Parameters
params.GuideReference = "default"


/* ##################################
    # Import necessary workflows    #
##################################### */


include { DataQC  } from "${params.PackagePath}/NF/modules/RawDataQC.nf"
include { ContigAssembly  } from "${params.PackagePath}/NF/modules/ContigAssembly.nf"
include { Scaffolding  } from "${params.PackagePath}/NF/modules/UnguidedScaffolding.nf"
include { GuidedScaffolding } from "${params.PackagePath}/NF/modules/GuidedScaffolding.nf"
include { GapCloser } from "${params.PackagePath}/NF/modules/GapClosing.nf"
include { Polish } from  "${params.PackagePath}/NF/modules/AssemblyPolishing.nf"

// Default Assembly Workflow.
workflow {

    // Filter Raw Data
    DataQC(params.ID,
           params.Fastq,
           params.KrakenReport,
           params.KrakenOutput,
           params.ExcludeTaxID,
           params.Threads,
           params.MinLength,
           params.MinQuality,
           params.PackagePath)

    // Run Contig Assembly.
    ContigAssembly(params.ID,
                    DataQC.out,
                    params.Threads,
                    params.ReadError,
                    params.PackagePath)


 // Run Unguided Scaffolding
    Scaffolding(params.ID,
                DataQC.out,
                ContigAssembly.out,
                params.Threads,
                params.NtLinkRounds,
                params.PackagePath)


    // Run Guided Scaffolding
    GuidedScaffolding(params.ID,
                    params.GuideReference,
                    Scaffolding.out,
                    params.Threads,
                    params.PackagePath)


    // Run Gap Closing 
    GapCloser(params.ID,
                DataQC.out,
                GuidedScaffolding.out,
                params.Threads,
                params.PackagePath)

    // Run Polishing
    Polish(params.ID,
         DataQC.out,
         GapCloser.out,
         params.Threads,
         params.PackagePath)

}

