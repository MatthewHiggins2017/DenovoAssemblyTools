# De Novo Assembly


# Installation

Note: In future this call all be wrapped into single setup script.

```

# 1) Clone package repo 
git clone https://github.com/MatthewHiggins2017/DenovoAssemblyTools
cd DenovoAssemblyTools

# 2) Create conda environment
conda env create -f ./Setup/DeNovoAssembly.yml
conda activate DeNovoAssembly

# 3) Install custom package. 
poetry install 

#4) Run setup script

bash ./Setup/Setup.sh

```





---------------------------------------------------------------------------------



# TO DO 
.

- How to change the Publish Directory index based on the order in the workflow. 

Expand assembly assement to include Quast and other custom python script to extract metrics. 

- If using Singularity Core the package will not work as setup.py is now discontinued, need to update structure / package so I can use it! To https://build.pypa.io/en/stable/

- For NCBI Decontamination tool screening make sure to point towards image file for singularity which is downloaded with the command itself otherwise it will not work.

## Environment Setup 


1) Use SingularityCore yaml file to create conda environment 

2) Download and install nextflow and move file to conda environment bin file 

3) Activate singularity and create all containers images from def files. 

4) Create nextflow.config file. 

5) Install https://github.com/ncbi/fcs/wiki/FCS-GX-quickstart and download database. Export necessary variable regarding SIF file and add fcs.py python file to environment bin. Alternatively try Conda version to see if this works https://bioconda.github.io/recipes/ncbi-fcs-gx/README.html as then can make into single singularity environment follows pre-established reciepe.  



To use singularity need to create nextflow.config file 
in the root of each project. This cannot be done with a nextflow 
process and has to be done before, e.g. part of a python script.
when triggering nextflow to run. 

```
singularity {
    enabled = true
}
```

For each process when specifying the sif with full path e.g.'/home/matt_h/Downloads/KRAKENTOOLS.img' and not ~/Downloads/KRAKENTOOLS.img' otherwise nextflow will try and pull the container from online instead of recognising it as local. 


For singularity to find local files need to add to the config file to bind users $HOME directory otherwise singularity exec commands will not find the correct files. 

```
singularity {
    enabled = true
    runOptions= "--bind $HOME:$HOME"
}
```


## (1) Data QC

* Scrubbing
* Decontamination
* Filtering

## (2) Contig Assembly

* Flye


## (3) Decontamination

* NCBI Foreign Contamination Screen

## (4) Unguided Scaffolding 

* NtLinks

## (5) Guided Scaffolding 

* Ragtag 

## (6) Gap Closing

* TGS - GapCloser 

## (7) Polishing 

* Racon

## (8) Tidy 


