# Inspired from: https://www.element84.com/machine-learning/running-rocm-5-4-2-onnx-and-pytorch-on-a-steamdeck/
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
#!/bin/bash
docker run -it \
--device=/dev/kfd --device=/dev/dri \
--ipc=host \
--cap-add=SYS_PTRACE \
--security-opt seccomp=unconfined \
--group-add video \
-e HSA_OVERRIDE_GFX_VERSION=10.3.0 \
jamesmcclain/onnxruntime-rocm:rocm5.7-ubuntu22.04
