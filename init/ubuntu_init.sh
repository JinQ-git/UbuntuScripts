#! /bin/bash

# User check (root)
if [ "$UID" -ne "0" ]; then
    echo "Please run this script as 'root' user" 1>&2
    exit 1
fi

# OS Version Check
if [ -f "/etc/os-release" ]; then
    source /etc/os-release
elif [ -f "/usr/lib/os-release" ]; then
    source /usr/lib/os-release
else
    ID=`lsb_release -is | tr '[:upper:]' '[:lower:]'` # ${ID,,} # bash 4.0 ~ (non-posix)
    VERSION_ID=`lsb_release -sr`
    PRETTY_NAME=`lsb_release -sd`
fi

if [ "${ID}" != "ubuntu" ]; then
    echo "Not Ubuntu: [${ID}]" 1>&2
    exit 1
fi

MAJOR_VERSION=`echo "${VERSION_ID}" | awk '{ print $0 ~ /^[0-9]+(\.[0-9]+)*$/ && int($0) >= 18 ? int($0) : 0 }'`
if [ "${MAJOR_VERSION}" -eq "0" ]; then 
    echo "18.04+ is required: [${VERSION_ID}]" 1>&2
    exit 1
fi

echo "[${PRETTY_NAME}]"

### From `Package Manager` ###

# Update (download) package information from all configured sources.
sudo apt-get update 
sudo apt-get install -y ca-certificates openssh-server curl vim net-tools tmux man-db manpages-posix manpages-dev manpages-posix-dev

# Install followings,
#   1. build-essential (gcc, make, and so on)
#   2. ninja-build
#   3. cmake
#   4. python3-pip
#   5. openjdk (one of 8, 11, 17, 18, 19, 21), default-jdk is 11
#   6. dotnet (one of 6, 7, 8)
#      ref> https://learn.microsoft.com/ko-kr/dotnet/core/install/linux-ubuntu-2204
sudo apt-get install -y build-essential ninja-build cmake python3-pip default-jdk
if [ "${MAJOR_VERSION}" -lt "20" ]; then 
    # Case Ubuntu 18.04 (bionic)
    sudo apt-get install -y openjdk-17-jdk dotnet-sdk-7.0
else
    # Case Ubuntu 20.04 (focal) and 22.04 (jammy)
    sudo apt-get install -y openjdk-21-jdk dotnet-sdk-8.0
fi

### From `script` ###

# LLVM (clang) - latest
curl -fsSL https://apt.llvm.org/llvm.sh | sudo -E bash -s -- all

# node.js - lts
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - && sudo apt-get install -y nodejs
#    NOTE: `setup_lts.x`: add a repo and key
#    NOTE: /etc/apt/sources.list.d/nodesource.list
#    NOTE: /etc/apt/keyrings/nodesource.gpg

# Docker
curl -fsSL https://get.docker.com | sudo -E bash -