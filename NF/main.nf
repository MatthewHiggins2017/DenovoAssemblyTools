#!/usr/bin/env nextflow

/*

Example Command:

nextflow ./NF/main.nf --ID MainTest --Fastq ~/Documents/Work/Github/Research/DenovoAssemblyTools/Examples/RawData/Test.fastq.gz --Threads 2 --KrakenReport ~/Documents/Work/Github/Research/DenovoAssemblyTools/Examples/RawData/Test.report --KrakenOutput ~/Documents/Work/Github/Research/DenovoAssemblyTools/Examples/RawData/Test.kraken --ExcludeTaxID 562 --Outdir ./MainTest --GuideReference ~/Documents/Work/Github/Research/DenovoAssemblyTools/Examples/RawData/reference.fasta --PackagePath /home/matt_h/Documents/Work/Github/Research/DenovoAssemblyTools 



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

// BUSCO Parameters
params.BuscoDatabase = 'eukaryota_odb10'


/* ##################################
    # Import necessary workflows    #
##################################### */


include { DataQC  } from "${params.PackagePath}/NF/modules/RawDataQC.nf"
include { ContigAssembly  } from "${params.PackagePath}/NF/modules/ContigAssembly.nf"
include { Scaffolding  } from "${params.PackagePath}/NF/modules/UnguidedScaffolding.nf"
include { GuidedScaffolding } from "${params.PackagePath}/NF/modules/GuidedScaffolding.nf"
include { GapCloser } from "${params.PackagePath}/NF/modules/GapClosing.nf"
include { Polish } from  "${params.PackagePath}/NF/modules/AssemblyPolishing.nf"

// Find cleaner way to do this!
include {AssemblyAssessment as AssemblyAssessOne} from "${params.PackagePath}/NF/modules/AssemblyAssessment.nf"
include {AssemblyAssessment as AssemblyAssessTwo} from "${params.PackagePath}/NF/modules/AssemblyAssessment.nf"
include {AssemblyAssessment as AssemblyAssessThree} from "${params.PackagePath}/NF/modules/AssemblyAssessment.nf"
include {AssemblyAssessment as AssemblyAssessFour} from "${params.PackagePath}/NF/modules/AssemblyAssessment.nf"
include {AssemblyAssessment as AssemblyAssessFive} from "${params.PackagePath}/NF/modules/AssemblyAssessment.nf"



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

    // Assessment
    AssemblyAssessOne(params.ID,
            ContigAssembly.out,
            params.Threads,
            params.BuscoDatabase,
            params.PackagePath,
            '01_Contig_Assembly')



 // Run Unguided Scaffolding
    Scaffolding(params.ID,
                DataQC.out,
                ContigAssembly.out,
                params.Threads,
                params.NtLinkRounds,
                params.PackagePath)


    AssemblyAssessTwo(params.ID,
            Scaffolding.out,
            params.Threads,
            params.BuscoDatabase,
            params.PackagePath,
            '02_Unguided_Scaffolding')


    // Run Guided Scaffolding
    GuidedScaffolding(params.ID,
                    params.GuideReference,
                    Scaffolding.out,
                    params.Threads,
                    params.PackagePath)

    AssemblyAssessThree(params.ID,
            GuidedScaffolding.out,
            params.Threads,
            params.BuscoDatabase,
            params.PackagePath,
            '03_Guided_Scaffolding')



    // Run Gap Closing 
    GapCloser(params.ID,
                DataQC.out,
                GuidedScaffolding.out,
                params.Threads,
                params.PackagePath)

    AssemblyAssessFour(params.ID,
            GuidedScaffolding.out,
            params.Threads,
            params.BuscoDatabase,
            params.PackagePath,
            '04_Gap_Closing')
    

    // Run Polishing
    Polish(params.ID,
         DataQC.out,
         GapCloser.out,
         params.Threads,
         params.PackagePath)

    
    AssemblyAssessFive(params.ID,
            GuidedScaffolding.out,
            params.Threads,
            params.BuscoDatabase,
            params.PackagePath,
            '05_Polishing')

}

