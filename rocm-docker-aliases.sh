#!/bin/bash
# ROCM_PYTORCH_IMAGE=jamesmcclain/pytorch-rocm:rocm5.4.2-ubuntu22.04 
ROCM_PYTORCH_IMAGE=rocm/pytorch:latest
VRAM="4G"

alias docker-stop-all="[[ ! -z \$(docker ps -aq) ]] \
	&& docker container stop \$(docker ps -aq)"

alias docker-rm-all="docker-stop > /dev/null 2>&1; \
	[[ ! -z \$(docker ps -aq) ]] \
	&& docker container rm \$(docker ps -aq)"

# The followinf is inspired from:
# https://www.element84.com/machine-learning/running-rocm-5-4-2-onnx-and-pytorch-on-a-steamdeck/
#
# Flags:
#
# - "--device=/dev/kfd" and "--device=/dev/dri" provide access to the GPU;
# - "--ipc=host" allows the container to use the IPC namespace of the host;
# - "-cap-add=SYS_PTRACE" grants `SYS_PTRACE` capability;
# - "-security-opt seccomp=unconfined" disables the default seccomp profile for the container;
# - "--group-add video" adds the container to the ‘video’ group, providing access to GPU devices;
# - "-e HSA_OVERRIDE_GFX_VERSION=10.3.0" export envvar `HSA_OVERRIDE_*` to container
#
# The `rocminfo` command states that the GPU in the SteamDeck is a `gfx1033`
# device.  Since ROCm 5.4.2 only officialy supports `gfx1030` devices, we are
# overriding the GPU identification to try to have ROCm working in the
# SteamDeck.
#
alias rocm-here="docker ps -a | grep pytorch-rocm > /dev/null 2>&1 \
	&& echo 'pytorch-rocm container already running, destroy it before binding to new dir' \
	&& true \
	|| docker run -it \
	--name pytorch-rocm \
	--device=/dev/kfd --device=/dev/dri \
	--ipc=host \
	--cap-add=SYS_PTRACE \
	--security-opt seccomp=unconfined \
	--group-add video \
	--shm-size ${VRAM} \
	-e HSA_OVERRIDE_GFX_VERSION=10.3.0 \
	--mount type=bind,source=\$(pwd),target=/workdir -w /workdir \
	${ROCM_PYTORCH_IMAGE} /bin/bash"

alias rocm="docker ps -a | grep pytorch-rocm > /dev/null 2>&1 \
	&& docker container start -i pytorch-rocm \
	|| docker run -it \
	--name pytorch-rocm \
	--device=/dev/kfd --device=/dev/dri \
	--ipc=host \
	--cap-add=SYS_PTRACE \
	--security-opt seccomp=unconfined \
	--group-add video \
	--shm-size ${VRAM} \
	-e HSA_OVERRIDE_GFX_VERSION=10.3.0 \
	${ROCM_PYTORCH_IMAGE} /bin/bash"

