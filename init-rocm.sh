#!/bin/bash

#
# Inspired by: https://www.element84.com/machine-learning/running-rocm-5-4-2-onnx-and-pytorch-on-a-steamdeck/
#

# Allow changing main installation
sudo steamos-readonly disable

# Initialize package manager
sudo pacman-key --init
sudo pacman-key --populate archlinux

# Note: after updating SteamOS to version 3.5.5 I had to reset pacman keys to
# fix invalid signature errors.
#
# From link:
# https://wiki.archlinux.org/title/Pacman/Package_signing#Resetting_all_the_keys
#
# > Remove or reset all the keys installed in your system by removing the
# > /etc/pacman.d/gnupg directory (as root) and by rerunning `pacman-key --init`
# > followed by `pacman-key --populate` to re-add the default keys. 

# Update package manager
sudo pacman -Syu

# Install docker and necessary dependencies
sudo pacman -Syu runc
sudo pacman -Syu containerd
sudo pacman -Syu docker

# Add user to `docker` group
sudo usermod -a -G docker $USER 
newgrp docker

# Enable necessary services
sudo systemctl enable containerd.service
sudo systemctl enable docker.service
# docker run hello-world

# Verify if `containerd` and `dockerd` are up
sudo systemctl is-enabled containerd.service
sudo systemcl is-enabled docker.service

# Return system to "read-only" state
sudo steamos-readonly enable

# Final steps
echo "Run `docker-onnx.sh` or `docker-pytorch.sh` to install the appropriate image[s]."
echo "You can also `source rocm-docker-aliases.sh` to simplify docker usage."
