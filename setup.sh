

# 1) Create and activate conda environment from yml
conda env create -f DeNovoAssembly.yml
conda activate DeNovoAssembly

#2) Download and install nextflow
# Guide: https://www.nextflow.io/docs/latest/install.html 


## Install Java dependency
curl -s https://get.sdkman.io | bash
source ~/.bashrc
conda activate DeNovoAssembly
sdk install java 17.0.10-tem

## Install Nextflow and place in conda env directory.
wget -qO- https://get.nextflow.io | bash
chmod +x nextflow
conda_dir=$(dirname $(dirname $(which conda)))
mv nextflow $conda_dir/envs/DeNovoAssembly/bin/

#3) Download and activate singularity containers from https://github.com/MatthewHiggins2017/SingularityCore/ 


#4) Download FCS-GX Scripts. 