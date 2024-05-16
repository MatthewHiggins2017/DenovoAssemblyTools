#!/usr/bin/env python3


'''

DeNovoAssembly Assemble --ID MainTest --Fastq ~/Documents/Work/Github/Research/DenovoAssemblyTools/Examples/RawData/Test.fastq.gz --Threads 2 --KrakenReport ~/Documents/Work/Github/Research/DenovoAssemblyTools/Examples/RawData/Test.report --KrakenOutput ~/Documents/Work/Github/Research/DenovoAssemblyTools/Examples/RawData/Test.kraken --ExcludeTaxID 562 --Outdir ./MainTest --GuideReference ~/Documents/Work/Github/Research/DenovoAssemblyTools/Examples/RawData/reference.fasta --Assembly ~/Documents/Work/Github/Research/DenovoAssemblyTools/Examples/RawData/Assembly.fasta

'''



import os
import sys
import argparse
import subprocess

# Full Assembly Pipeline
def FullAssembly(args):

    print('\nRUNNING FULL ASSEMBLY\n')

    NextFlowCommand = f'''nextflow {args.PackagePath}/NF/main.nf \
        --ID {args.ID} \
        --Fastq  {args.Fastq} \
        --Threads {args.Threads} \
        --KrakenReport {args.KrakenReport} \
        --KrakenOutput {args.KrakenOutput} \
        --ExcludeTaxID {args.ExcludeTaxID} \
        --Outdir {args.Outdir} \
        --GuideReference {args.GuideReference} \
        --PackagePath {args.PackagePath} \
        --Assembly {args.Assembly} '''

    subprocess.run(NextFlowCommand,shell=True)

    return 

# Module: Data Quality Control
def DataQC(args):

    print('\nRUNNING DATA QC\n')

    NextFlowCommand = f'''nextflow {args.PackagePath}/NF/modules/RawDataQC.nf \
        --ID {args.ID} \
        --Fastq  {args.Fastq} \
        --Threads {args.Threads} \
        --KrakenReport {args.KrakenReport} \
        --KrakenOutput {args.KrakenOutput} \
        --ExcludeTaxID {args.ExcludeTaxID} \
        --Outdir {args.Outdir} \
        --GuideReference {args.GuideReference} \
        --PackagePath {args.PackagePath} \
        --Assembly {args.Assembly} '''

    subprocess.run(NextFlowCommand,shell=True)

    return 

# Module: 
def ContigAssembly(args):

    print('\nRUNNING CONTIG ASSEMBLY\n')

    NextFlowCommand = f'''nextflow {args.PackagePath}/NF/modules/ContigAssembly.nf \
        --ID {args.ID} \
        --Fastq  {args.Fastq} \
        --Threads {args.Threads} \
        --KrakenReport {args.KrakenReport} \
        --KrakenOutput {args.KrakenOutput} \
        --ExcludeTaxID {args.ExcludeTaxID} \
        --Outdir {args.Outdir} \
        --GuideReference {args.GuideReference} \
        --PackagePath {args.PackagePath}\
        --Assembly {args.Assembly} '''
    
    subprocess.run(NextFlowCommand,shell=True)


    return 

# Module: 
def ContaminationRemoval(args):

    print('\nRUNNING CONTAMINATION REMOVAL\n')

    NextFlowCommand = f'''nextflow {args.PackagePath}/NF/modules/ForeignContaminationScreen.nf \
        --ID {args.ID} \
        --Fastq  {args.Fastq} \
        --Threads {args.Threads} \
        --KrakenReport {args.KrakenReport} \
        --KrakenOutput {args.KrakenOutput} \
        --ExcludeTaxID {args.ExcludeTaxID} \
        --Outdir {args.Outdir} \
        --GuideReference {args.GuideReference} \
        --PackagePath {args.PackagePath}\
        --Assembly {args.Assembly} '''
    
    subprocess.run(NextFlowCommand,shell=True)

    return 

# Module: 
def UnguidedScaffolding(args):

    print('\nRUNNING UNGUIDED SCAFFOLDING\n')

    NextFlowCommand = f'''nextflow {args.PackagePath}/NF/modules/UnguidedScaffolding.nf \
        --ID {args.ID} \
        --Fastq  {args.Fastq} \
        --Threads {args.Threads} \
        --KrakenReport {args.KrakenReport} \
        --KrakenOutput {args.KrakenOutput} \
        --ExcludeTaxID {args.ExcludeTaxID} \
        --Outdir {args.Outdir} \
        --GuideReference {args.GuideReference} \
        --PackagePath {args.PackagePath}\
        --Assembly {args.Assembly} '''
    
    subprocess.run(NextFlowCommand,shell=True)

    return 

# Module: 
def GuidedScaffolding(args):

    print('\nRUNNING GUIDED SCAFFOLDING\n')

    NextFlowCommand = f'''nextflow {args.PackagePath}/NF/modules/GuidedScaffolding.nf \
        --ID {args.ID} \
        --Fastq  {args.Fastq} \
        --Threads {args.Threads} \
        --KrakenReport {args.KrakenReport} \
        --KrakenOutput {args.KrakenOutput} \
        --ExcludeTaxID {args.ExcludeTaxID} \
        --Outdir {args.Outdir} \
        --GuideReference {args.GuideReference} \
        --PackagePath {args.PackagePath} \
        --Assembly {args.Assembly} '''
    
    subprocess.run(NextFlowCommand,shell=True)


    return 

# Module: 
def AssemblyPolishing(args):

    print('\nRUNNING ASSEMBLY POLISHING\n')

    NextFlowCommand = f'''nextflow {args.PackagePath}/NF/modules/AssemblyPolishing.nf \
        --ID {args.ID} \
        --Fastq  {args.Fastq} \
        --Threads {args.Threads} \
        --KrakenReport {args.KrakenReport} \
        --KrakenOutput {args.KrakenOutput} \
        --ExcludeTaxID {args.ExcludeTaxID} \
        --Outdir {args.Outdir} \
        --GuideReference {args.GuideReference} \
        --PackagePath {args.PackagePath} \
        --Assembly {args.Assembly} '''
    
    subprocess.run(NextFlowCommand,shell=True)


    return

# Module: 
def AssemblyAssess(args):

    print('\nRUNNING ASSEMBLY ASSESSMENT\n')

    NextFlowCommand = f'''nextflow {args.PackagePath}/NF/modules/AssemblyAssessment.nf \
        --ID {args.ID} \
        --Fastq  {args.Fastq} \
        --Threads {args.Threads} \
        --KrakenReport {args.KrakenReport} \
        --KrakenOutput {args.KrakenOutput} \
        --ExcludeTaxID {args.ExcludeTaxID} \
        --Outdir {args.Outdir} \
        --GuideReference {args.GuideReference} \
        --PackagePath {args.PackagePath} \
        --Assembly {args.Assembly} '''
    
    subprocess.run(NextFlowCommand,shell=True)

    return 



# Share Arguments
def add_shared_arguments(parser, PackagePath):
    parser.add_argument('--PackagePath',
                        help='Path to the package directory so all nextflow scripts and singularity containers are accessible.',
                        type=str,
                        default=PackagePath)

    parser.add_argument('--ID',
                        help='Define the ID of your given assembly run. This will be used to name files',
                        type=str,
                        required=True)

    parser.add_argument('--Outdir',
                        help='Define the output path',
                        type=str,
                        required=True)

    parser.add_argument('--Fastq',
                        help='Path to ONT input data.',
                        type=str,
                        default=False)

    parser.add_argument('--Threads',
                        help='Define the number of available threads',
                        type=int,
                        default=2)

    parser.add_argument('--KrakenReport',
                        help='Path to the Kraken Report associated with ONT input data',
                        type=str,
                        default=False)

    parser.add_argument('--KrakenOutput',
                        help='Path to the Kraken Output associated with ONT input data',
                        type=str,
                        default=False)

    parser.add_argument('--ExcludeTaxID',
                        help='Define the TaxonomicIDs which should be used to filter the raw ONT data. Any reads classified according to these IDs will be removed. Use https://www.ncbi.nlm.nih.gov/taxonomy to identify TaxIDs of interest',
                        type=str,
                        default=False)

    parser.add_argument('--MinLength',
                        help='ONT input data minimum length.',
                        default=1000,
                        type=int)

    parser.add_argument('--MinQuality',
                        help='ONT input data minimum quality.',
                        default=7,
                        type=int)

    parser.add_argument('--ReadError',
                        help='ONT Read Error Probability. Note this should match the Min Quality parameter. E.g. If Q12 = ~0.06 Error Rate',
                        default=0.06,
                        type=float)

    parser.add_argument('--NtLinkRounds',
                        help='Define rounds of unguided scaffolding',
                        default=3,
                        type=int)

    parser.add_argument('--GuideReference',
                        help='Path to fasta file which should be used as guided. This will be used for guided scaffolding with RagTag and assembly assessment via Qaust.',
                        type=str,
                        default=False)

    parser.add_argument('--Assembly',
                        help='Path to preexisting assembly',
                        type=str,
                        default=False)


def main():
    
    print("\nDeNovo Assembly\n\nMatthew Higgins\nmatthew.higgins2017@gmail.com")

    # Obtain Package Path
    # Key variable to point towards NextFlow and Singualrity scripts and containers respectively.
    PackagePath = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))) 


    # Argument Parser
    parser = argparse.ArgumentParser(description='DeNovo Assembly')

    subparsers = parser.add_subparsers(help="Options")


    # Full Assembly (Sub Parser One)
    parser_sub_one = subparsers.add_parser('Assemble',
                                        help='Full Assembly')
    add_shared_arguments(parser_sub_one,PackagePath)
    parser_sub_one.set_defaults(func=FullAssembly)


    # Assembly Assessment (Sub Parser Two)
    parser_sub_two = subparsers.add_parser('Assess',
                                        help='Assessment of Assembly')
    add_shared_arguments(parser_sub_two,PackagePath)
    parser_sub_two.set_defaults(func=AssemblyAssess)


    # Data QC Module (Sub Parser Three)
    parser_sub_three = subparsers.add_parser('DataQC',
                                        help='DataQC module.')
    add_shared_arguments(parser_sub_three,PackagePath)
    parser_sub_three.set_defaults(func=DataQC)


    # Contig Assembly Module (Sub Parser Four)
    parser_sub_four = subparsers.add_parser('ContigAssembly',
                                        help='Contig Assembly module.')
    add_shared_arguments(parser_sub_four,PackagePath)
    parser_sub_four.set_defaults(func=ContigAssembly)


    # ContaminationRemoval Module (Sub Parser Five)
    parser_sub_five = subparsers.add_parser('Decontamination',
                                        help='NCBI Foreign Decontamination module.')
    add_shared_arguments(parser_sub_five,PackagePath)
    parser_sub_five.set_defaults(func=ContigAssembly)


    # Unguided Scaffolding Module (Sub Parser Six)
    parser_sub_six = subparsers.add_parser('UnguidedScaffolding',
                                        help='Unguided Scaffolding module.')
    add_shared_arguments(parser_sub_six,PackagePath)
    parser_sub_six.set_defaults(func=UnguidedScaffolding)


    # Guided Scaffolding Module (Sub Parser Seven)
    parser_sub_seven = subparsers.add_parser('GuidedScaffolding',
                                        help='Guided Scaffolding module.')
    add_shared_arguments(parser_sub_seven,PackagePath)
    parser_sub_seven.set_defaults(func=GuidedScaffolding)


    # Guided Scaffolding Module (Sub Parser Eight)
    parser_sub_eight = subparsers.add_parser('AssemblyPolishing',
                                        help='Assembly Polishing module.')
    add_shared_arguments(parser_sub_eight,PackagePath)
    parser_sub_eight.set_defaults(func=AssemblyPolishing)


    # If no options specified add help
    if len(sys.argv) <= 1:
        sys.argv.append('--help')

    # Trigger parser specific arguments. 
    args = parser.parse_args()
    args.func(args)





# Main Function
if __name__ == "__main__":
    main()