#!/usr/bin/env nextflow

/*

nextflow Scripts/UnguidedScaffolding.nf --ID TestQC --Fastq ~/Documents/Work/Github/Research/DenovoAssemblyTools/Examples/RawData/Test.fastq --Assembly ~/Documents/Work/Github/Research/DenovoAssemblyTools/Examples/RawData/assembly.fasta


*/

// General Parameters
params.ID = "Test"
params.Assembly = "default"
params.Fastq = "default"
params.Threads = 2
params.Outdir = "./TestRun"


// NtLink Parameters
params.NtLinkRounds = 3



workflow {
    NtLink(params.ID,
            params.Fastq,
            params.Assembly,
            params.Threads,
            params.NtLinkRounds)
}


process NtLink {

    // Define path to container
    container '/home/matt_h/Downloads/NtLink.sif'

    // Defines where output files will be stored on process completion
    publishDir "${params.Outdir}/04_UnguidedScaffolding"

    // Input variables required
    input:
    val(ID)
    val(fastq)
    val(assembly)
    val(threads)
    val(rounds)


    // Output variable which is expected and checked for.
    output:
    path "${ID}_NtLink_Assembly.fasta"

    // Run Script
    script:
    """
    ln -s ${fastq} ./reads.fastq ; \
    ln -s ${assembly} ./assembly.fasta ; \
    ntLink_rounds run_rounds target=./assembly.fasta \
                        reads=./reads.fastq  \
                        rounds=${rounds} \
                        t=${threads} ; \
    mv ./assembly.fasta.k32.w100.z1000.ntLink.${rounds}rounds.fa ./${ID}_NtLink_Assembly.fasta


    """

}


