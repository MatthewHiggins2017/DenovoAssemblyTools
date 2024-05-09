#!/usr/bin/env python3


'''

DeNovoAssembly Assemble --ID MainTest --Fastq ~/Documents/Work/Github/Research/DenovoAssemblyTools/Examples/RawData/Test.fastq --Threads 2 --KrakenReport ~/Documents/Work/Github/Research/DenovoAssemblyTools/Examples/RawData/Test.report --KrakenOutput ~/Documents/Work/Github/Research/DenovoAssemblyTools/Examples/RawData/Test.kraken --ExcludeTaxID 562 --Outdir ./MainTest --GuideReference ~/Documents/Work/Github/Research/DenovoAssemblyTools/Examples/RawData/reference.fasta --PackagePath /home/matt_h/Documents/Work/Github/Research/DenovoAssemblyTools 


'''



import os
import sys
import argparse
import subprocess

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
        --PackagePath {args.PackagePath} '''

    subprocess.run(NextFlowCommand,shell=True)

    return 


def AssemblyAssess(args):
    print('Hello World')
    return 



def main():
    print("\nDeNovo Assembly\nMatthew Higgins\n")

    # Obtain Package Path
    PackagePath = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))) 

    print("Package Location:",PackagePath)


    ###############################
    # Parse Command Line Arguments
    ###############################
    parser = argparse.ArgumentParser(description='DeNovo Assembly')


    # Subparser to assess an assembly
    subparsers = parser.add_subparsers(help="Options")




    ###############################
    # Sub Parser One - Assembly
    ###############################
    parser_sub_one = subparsers.add_parser('Assemble',
                                        help='Full Assembly')

    parser_sub_one.add_argument('--PackagePath',
                                help='Path to the package directory so all nextflow scripts and singularity containers are accessible.',
                                type=str,
                                default=PackagePath)


    parser_sub_one.add_argument('--ID',
                                help='',
                                type=str,
                                required=True)
    
    
    parser_sub_one.add_argument('--Outdir',
                                    help='',
                                    type=str,
                                    required=True)

    parser_sub_one.add_argument('--Fastq',
                                help='',
                                type=str)

    parser_sub_one.add_argument('--Threads',
                                    help='',
                                    type=int,
                                    default=2)
    
    parser_sub_one.add_argument('--KrakenReport',
                                help='',
                                type=str)
    
    parser_sub_one.add_argument('--KrakenOutput',
                                help='',
                                type=str)

    parser_sub_one.add_argument('--ExcludeTaxID',
                                help='',
                                type=str)
    

    parser_sub_one.add_argument('--MinLength',
                                help='',
                                default=1000,
                                type=int)
    

    parser_sub_one.add_argument('--MinQuality',
                                help='',
                                default=7,
                                type=int)
    

    parser_sub_one.add_argument('--ReadError',
                                help='',
                                default=0.06,
                                type=float)
    
    
    parser_sub_one.add_argument('--NtLinkRounds',
                                help='',
                                default=0.06,
                                type=int)
    
    parser_sub_one.add_argument('--GuideReference',
                                help='',
                                type=str)
    

    parser_sub_one.set_defaults(func=FullAssembly)



    ###############################
    # Sub Parser Two - Assess
    ###############################
    parser_sub_two = subparsers.add_parser('Assess',
                                        help='Assessment of Assembly')

    parser_sub_two.add_argument('--Prefix','-P',
                            help='Prefix for all files generated',
                            required=True)

    parser_sub_two.set_defaults(func=AssemblyAssess)



    ###############################
    # No Arguments
    ###############################

    # If no options specified add help
    if len(sys.argv) <= 1:
        sys.argv.append('--help')



    # Trigger parser specific arguments. 
    args = parser.parse_args()
    args.func(args)








if __name__ == "__main__":
    main()