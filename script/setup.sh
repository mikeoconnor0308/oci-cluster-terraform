# install mono
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
sudo apt-get update && sudo apt-get -y install apt-transport-https
sudo echo "deb https://download.mono-project.com/repo/ubuntu stable-xenial main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list
sudo apt-get update && sudo apt-get -y install mono-devel
# set up paths for openmm plugin, add them to current shell and bashrc for any ssh connections.
echo 'export LD_LIBRARY_PATH=~/openmm/lib:$LD_LIBRARY_PATH' >> ~/.bashrc
echo 'export OPENMM_PLUGIN_DIR=~/openmm/lib/plugins' >> ~/.bashrc
export LD_LIBRARY_PATH=~/openmm/lib:$LD_LIBRARY_PATH
export OPENMM_PLUGIN_DIR=~/openmm/lib/plugins
# open up the ports we need:
sudo iptables -I INPUT 1 -p tcp --dport 8080 -j ACCEPT
sudo iptables -I INPUT 1 -p tcp --dport 80 -j ACCEPT
sudo bash -c "iptables-save > /etc/iptables.rules"