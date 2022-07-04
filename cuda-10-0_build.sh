# INSTALL CUDA-10.0 & CUDA-TOOLKIT-10.0

sudo apt clean && sudo apt update && sudo apt purge cuda && sudo apt purge nvidia-* && sudo apt autoremove
sudo apt-get install freeglut3 freeglut3-dev libxi-dev libxmu-dev

#wget -p https://developer.nvidia.com/compute/cuda/10.0/Prod/local_installers/cuda-repo-ubuntu1804-10-0-local-10.0.130-410.48_1.0-1_amd64 ~/Downloads
#wget -p http://developer.download.nvidia.com/compute/cuda/10.0/Prod/patches/1/cuda-repo-ubuntu1804-10-0-local-nvjpeg-update-1_1.0-1_amd64.deb ~/Downloads
sudo dpkg -i ~/Downloads/cuda-repo-ubuntu1804-10-0-local-10.0.130-410.48_1.0-1_amd64.deb
sudo dpkg -i ~/Downloads/cuda-repo-ubuntu1804-10-0-local-nvjpeg-update-1_1.0-1_amd64.deb
sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub

sudo apt-get install -y cuda-10-0 cuda-toolkit-10-0

echo "export PATH=/usr/local/cuda-10.0/bin:$PATH" >> ~/.bashrc
echo "export LD_LIBRARY_PATH=/usr/local/cuda-10.0/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}" >> ~/.bashrc




