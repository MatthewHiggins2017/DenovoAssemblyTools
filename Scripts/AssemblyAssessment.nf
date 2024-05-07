#!/usr/bin/env nextflow

/*

nextflow Scripts/AssemblyAssessment.nf --ID TestQC --Fastq ~/Documents/Work/Github/Research/DenovoAssemblyTools/Examples/RawData/Test.fastq --Assembly ~/Documents/Work/Github/Research/DenovoAssemblyTools/Examples/RawData/assembly.fasta


*/

// General Parameters
params.ID = "Test"
params.Assembly = "default"
params.Fastq = "default"
params.Threads = 2
params.Outdir = "./TestRun"

// BUSCO Parameters
params.BuscoDatabase = ''

// Quast Parameters
params.BuscoDatabase = ''


