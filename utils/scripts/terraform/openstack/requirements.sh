#! /bin/bash
ocm_binpath=$1
sudo dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
sudo dnf install -y python39-devel git redhat-lsb jq podman dnf-plugins-core java-1.8.0-openjdk unzip chromium chromedriver
sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
sudo dnf install -y terraform
sudo pip3 install python-terraform
sudo pip3 install --ignore-installed pyyaml
git config --global http.sslVerify "false"
sudo mkdir -p ~/bin
sudo curl -Lo ~/bin/ocm $ocm_binpath
sudo chmod +x ~/bin/ocm
sudo mkdir -p /home/jenkins/workspace
sudo chmod 777 /home/jenkins/workspace
