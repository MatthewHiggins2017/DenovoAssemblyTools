# De Novo Assembly


# Installation

Note: In future this call all be wrapped into single setup script.

```

# 1) Clone package repo 
git clone https://github.com/MatthewHiggins2017/DenovoAssemblyTools
cd DenovoAssemblyTools

# 2) Run Setup Script
bash ./Setup/Setup.sh


```
# Useage

```

conda activate DeNovoAssembly

DeNovoAssembly --help

```


---------------------------------------------------------------------

# TO DO 

Sort out $conda_dir = Figure out what is going on.

* Move all containder .def file to necessary directory

* Simplify the setup into single script 

* Test main.nf script 

* Update assembly.py python file as control script parsing necessary parameters to run the main.nf script. 

* Write markdown documentation. 

.------------------------------------
## Other To Do

Setup:

* How to change the Publish Directory index based on the order in the workflow. 

* For NCBI Decontamination tool screening make sure to point towards image file for singularity which is downloaded with the command itself otherwise it will not work.

NextFlow Expansion:

* Expand assembly assement to include Quast and other custom python script to extract metrics. 

* Change nextflow so container path variable is based on user defined parameter and this can be established with python as shown in the assembly.py script.

Python Wrapper:

* Run the main nextflow script

------------------------------------------------------------------------------------------


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



