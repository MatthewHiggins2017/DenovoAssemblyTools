#############
# Stage One
#############
# 1) Create and activate conda environment from yml

conda env create -f DeNovoAssembly.yml
conda activate DeNovoAssembly

#############
# Stage Two
#############
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

###############
# Stage Three #
###############

#3) Create and activate all singularity containers defined in repo

cd ./Containers

for file in *.def; do
    if [ -f "$file" ]; then
        echo "Processing $file"
        singularity build --fakeroot "${file%.def}.sif" "$file"
    fi
done

# Move all precursor files to given directory
mkdir Precursors
mv * ./Precursors
mv ./Precursors/*.sif ./


###############
# Stage Four #
###############
# 4) Download FCS-GX and external singularity containers. 

# Download FCS-GX Singularity Image
curl https://ftp.ncbi.nlm.nih.gov/genomes/TOOLS/FCS/releases/latest/fcs-gx.sif -Lo fcs-gx.sif
export FCS_DEFAULT_IMAGE=fcs-gx.sif

# Download FCS-GX script and add to bin! 
curl -LO https://github.com/ncbi/fcs/raw/main/dist/fcs.py
chmod +x fcs.py
mv fcs.py $conda_dir/envs/DeNovoAssembly/bin/

cd ../

###############
# Stage Five #
###############
# 5) Download External Databases. 

mkdir DB
cd  ./DB

# Make Directory for FCS-GX databse.
mkdir GXDB

curl -LO https://github.com/peak/s5cmd/releases/download/v2.0.0/s5cmd_2.0.0_Linux-64bit.tar.gz
tar -xvf s5cmd_2.0.0_Linux-64bit.tar.gz

LOCAL_DB="./GXDB/"
./s5cmd  --no-sign-request cp  --part-size 50  --concurrency 50 s3://ncbi-fcs-gx/gxdb/latest/all.* $LOCAL_DB. 


###############
# Stage Six   #
###############

# 6) Add nextflow.config file to necessary location. 