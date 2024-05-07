# De Novo Assembly


# TO DO 




## Environment Setup 


1) Use SingularityCore yaml file to create conda environment 
2) Download and install nextflow and move file to conda environment bin file 
3) Activate singularity and create all containers images from def files. 
4) Create nextflow.config file. 
5) Install https://github.com/ncbi/fcs/wiki/FCS-GX-quickstart and download database



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


