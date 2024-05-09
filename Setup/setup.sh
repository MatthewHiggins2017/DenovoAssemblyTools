#############
# Stage One
#############
# Create and activate conda environment from yml

conda env create -f ./Setup/DeNovoAssembly.yml
conda activate DeNovoAssembly
export conda_dir=$(conda info --base)


###############
# Stage Two
###############
# Download and install nextflow
# Guide: https://www.nextflow.io/docs/latest/install.html 


## Install Java dependency
curl -s https://get.sdkman.io | bash
source ~/.bashrc
conda activate DeNovoAssembly
sdk install java 17.0.10-tem

## Install Nextflow and place in conda env directory.
wget -qO- https://get.nextflow.io | bash
chmod +x nextflow
mv nextflow $conda_dir/envs/DeNovoAssembly/bin/

## Move .nextflow.config file to root {~/.nextflow.config}
## Double check this works. 
mv nextflow.config ~/.nextflow.config


## TO DO!!!!!

#############
# Stage Three
#############
# Install the DeNovoAssemblyTools package.

# Built as python package so can use poetry
poetry install


###############
# Stage Four 
###############
#4) Build Singularity Containers

cd ./Containers

for file in *.def; do
    if [ -f "$file" ]; then
        echo "Processing $file"
        singularity build --fakeroot "${file%.def}.sif" "$file"
    fi
done

cd ../

###############
# Stage Five 
###############
# Download external containers, scripts and databases. 



########## FCS-GX (Foreign Contamination Screen) ####################

# Download FCS-GX Singularity Image
curl https://ftp.ncbi.nlm.nih.gov/genomes/TOOLS/FCS/releases/latest/fcs-gx.sif -Lo ./Containers/fcs-gx.sif

# Download FCS-GX script and add to environment bin
curl -LO https://github.com/ncbi/fcs/raw/main/dist/fcs.py

# Add python shebang as this is missing in FCS script  
sed -i '1s|^|#!/usr/bin/env python3\n|' fcs.py

chmod +x fcs.py

# Move script to environment bin
mv fcs.py $conda_dir/envs/DeNovoAssembly/bin/


mkdir -p DB/GXDB/

cd ./DB/GXDB

curl -LO https://github.com/peak/s5cmd/releases/download/v2.0.0/s5cmd_2.0.0_Linux-64bit.tar.gz

tar -xvf s5cmd_2.0.0_Linux-64bit.tar.gz

./s5cmd  --no-sign-request cp  --part-size 50  --concurrency 50 s3://ncbi-fcs-gx/gxdb/latest/all.* ./. 

cd ../../

##########################################################################


