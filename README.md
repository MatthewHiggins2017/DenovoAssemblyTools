# De Novo Assembly

# Introduction 


The following Python package utilizes Nextflow and Singularity to furnish a comprehensive De Novo Assembly Toolkit. Its modular structure enables the execution of each stage of the De Novo assembly pipeline individually or collectively, facilitating the transition from raw ONT data to a polished assembly. Presently, its configuration is tailored specifically for ONT data processing.


# Dependencies

* [python](https://www.python.org/downloads/release/python-3100/) >= 3.10
* [mamba](https://github.com/mamba-org/mamba) >= 1.5.8


# Installation

Following the instructions below will install the De Novo Assembly package and all dependencies, including Singularity and NextFlow. 

```

# 1) Clone package repo 
git clone https://github.com/MatthewHiggins2017/DenovoAssemblyTools
cd DenovoAssemblyTools

# 2) Run Setup Script
bash ./Setup/Setup.sh


-----------------------------------------------------------------------------------------------

```
# Useage

To use the DeNovo Assembly ToolKit package you always need to activate the conda environment as shown below:

```

conda activate DeNovoAssembly

DeNovoAssembly --help

```

The following commands are available for use:

```
# Full Assembly Pipeline (Raw Data -> Polished Assembly)
DeNovoAssembly Assemble <parameters>

# Assembly Assessment Module
DeNovoAssembly Assess <parameters>

# DataQC Module
DeNovoAssembly DataQC <parameters>

# Contig Assembly Module
DeNovoAssembly ContigAssembly <parameters>

# Unguided Scaffolding Module
DeNovoAssembly UnguidedScaffolding  <parameters>

# Guided Scaffolding Module
DeNovoAssembly GuidedScaffolding <parameters>

# Assembly Polishing Module
DeNovoAssembly AssemblyPolishing <parameters>


```

Please see below a test command to run the full pipeline using test data provided. Note be sure to change the file paths accordingly.

```

DeNovoAssembly Assemble --ID Test \
 --Fastq /Full/Path/To/Package/DenovoAssemblyTools/Examples/RawData/Test.fastq.gz \
--Threads 2 \
--KrakenReport /Full/Path/To/Package/DenovoAssemblyTools/Examples/RawData/Test.report \
--KrakenOutput /Full/Path/To/Package/DenovoAssemblyTools/Examples/RawData/Test.kraken \
--ExcludeTaxID 562 \
--Outdir /Full/Path/To/Package/DenovoAssemblyTools/Examples/MainTest \
--GuideReference /Full/Path/To/Package/DenovoAssemblyTools/Examples/RawData/reference.fasta \
--BuscoDatabase eukaryota_odb10


```


-------------------------------------------------------------

# Parameters

| Argument | Description | Type | Default Value | Required |
| --- | --- | --- | --- | --- |
| `--PackagePath` | Path to the package directory so all nextflow scripts and singularity containers are accessible. | str | PackagePath | No |
| `--ID` | Define the ID of your given assembly run. This will be used to name files. | str | None | Yes |
| `--Outdir` | Define the output path. | str | None | Yes |
| `--Fastq` | Path to ONT input data. | str | False | No |
| `--Threads` | Define the number of available threads. | int | 2 | No |
| `--KrakenReport` | Path to the Kraken Report associated with ONT input data. | str | False | No |
| `--KrakenOutput` | Path to the Kraken Output associated with ONT input data. | str | False | No |
| `--ExcludeTaxID` | Define the TaxonomicIDs which should be used to filter the raw ONT data. Any reads classified according to these IDs will be removed. Use https://www.ncbi.nlm.nih.gov/taxonomy to identify TaxIDs of interest. | str | False | No |
| `--MinLength` | ONT input data minimum length. | int | 1000 | No |
| `--MinQuality` | ONT input data minimum quality. | int | 7 | No |
| `--ReadError` | ONT Read Error Probability. Note this should match the Min Quality parameter. E.g. If Q12 = ~0.06 Error Rate. | float | 0.06 | No |
| `--NtLinkRounds` | Define rounds of unguided scaffolding. | int | 3 | No |
| `--GuideReference` | Path to fasta file which should be used as guided. This will be used for guided scaffolding with RagTag and assembly assessment via Qaust. | str | False | No |
| `--Assembly` | Path to preexisting assembly. | str | False | No |


-------------------------------------------------------------

# Tools Utilised

Below is a list of tools incoporated into the De Novo Assembly package.

**Data QC**

* [Kraken2](https://ccb.jhu.edu/software/kraken2/)
* [KrakenTools]()
* [Minimap2]()
* [Yacrd]()
* [Chopper]()

**Contig Assembly**

* [FLYE]()
* [NCBI Decontamination Screening]()

**Scaffolding**

* [NtLinks]()
* [RagTag]()

**Assembly Polishing**

* [TgsGapCloser]()
* [Racon]()
