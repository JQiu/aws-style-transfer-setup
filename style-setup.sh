#!/bin/bash
# JQ : this shell script helps streamline setting up a gpu instance for style
#      transfer on AWS EC instance

cd ~
sudo apt-get update

# 1. Install CUDA 7.5 (change url to current CUDA version if outdated)
wget http://developer.download.nvidia.com/compute/cuda/7.5/Prod/local_installers/cuda-repo-ubuntu1404-7-5-local_7.5-18_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1404-7-5-local_7.5-18_amd64.deb
sudo apt-get update
sudo apt-get install cuda

# 2. Install torch
git clone https://github.com/torch/distro.git ~/torch --recursive
cd ~/torch; bash install-deps;
./install.sh
source ~/.bashrc

# 3. Install loadcaffe
sudo apt-get install libprotobuf-dev protobuf-compiler
luarocks install loadcaffe

# 4. Install CUDA backend for torch
luarocks install cutorch
luarocks install cunn

# 5. Install cuDNN (update this url for newer versions)
wget https://docs.google.com/uc?export=download&confirm=iOd4&id=0B5PDpJjOhOsxWjQ2MkVQMDFNaGc
tar -zxf cudnn-7.0-linux-x64-v4.0-prod.tgz
cd cuda
sudo cp lib64/* /usr/local/cuda/lib64/
sudo cp include/cudnn.h /usr/local/cuda/include/
cd ~
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:~/cuda/lib64

# JQ: you may have to redo the export process every now and then

# 6. Clone jcjohnson's implementation of original version
git clone https://github.com/jcjohnson/neural-style.git

# usage:
# cd ~/neural-style
# th neural_style.lua -style_image <image.jpg> -content_image <image.jpg> -image_size <size>

# 7. Clone patched CNNMRF version
git clone https://github.com/JQiu/CNNMRF.git

# usage:
# cd ~/CNNMRF
# qlua cnnmrf.lua -content_image <content> -style_image <style> -image_size <size> [-content_weight 63]
# JQ: -content_weight 63 preserves structure similar to original version
