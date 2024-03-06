#! /bin/bash

INSTALL_DIR="/opt/swift"

#
# User check (root)
#
if [ "$UID" -ne "0" ]; then
    echo "Please run this script as 'root' user" 1>&2
    exit 1
fi

#
# Check Destination (Install Location)
#
if [ ! -e "${INSTALL_DIR}" ]; then
    mkdir -p -m 755 "${INSTALL_DIR}"
fi
if [ ! -d "${INSTALL_DIR}" ]; then
    echo "${INSTALL_DIR} is not a directory!!" 1>&2
    exit(1)
fi

#
# Making a temporary random directory
#
CURR_DIR=$(mktemp -d /tmp/swift.XXXXXXX)
if [ $? -ne 0 ]; then
    echo "$0: Can't create temp directory..." 1>&2
    exit 1
fi

# Set trap to clean up temp directory
trap 'rm -rf -- "${CURR_DIR}"' EXIT

# Change Current Directory
cd "${CURR_DIR}"

#
# OS Version Check
#    /etc/os-release -> /usr/lib/os-release
#    ref> https://www.freedesktop.org/software/systemd/man/latest/os-release.html
#

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

#
# Machine Architecture
#
ARCH=`uname -m | tr '[:upper:]' '[:lower:]'` # x86_64, aarch64 \\ i386, i686 not support
# uname -m: machine hardware name
# uname -i: hardware platform

if [ "${ARCH}" != "x86_64" -a "${ARCH}" != "aarch64" ]; then
    echo "Target Platform must be one of [x86_64 or aarch64]: [${ARCH}]" 1>&2
    exit 1
if

if [ "${MAJOR_VERSION}" -lt "20" -a "${ARCH}" = "aarch64" ]; then
    echo "aarch64 version is not support on your system: [$VERSION_ID]" 1>&2
    exit 1
fi

#
# Install Swift (tarball)
#

# 0. Dependency
apt-get update
case "${MAJOR_VERSION}" in
    "18")
        apt-get install -y binutils git libc6-dev libcurl4 libedit2 libgcc-5-dev libpython2.7 libsqlite3-0 libstdc++-5-dev libxml2 pkg-config tzdata zlib1g-dev
        ;;
    "20")
        apt-get install -y binutils git gnupg2 libc6-dev libcurl4 libedit2 libgcc-9-dev libpython2.7 libsqlite3-0 libstdc++-9-dev libxml2 libz3-dev pkg-config tzdata uuid-dev zlib1g-dev
        ;;
    "22")
        apt-get install -y binutils git gnupg2 libc6-dev libcurl4-openssl-dev libedit2 libgcc-9-dev libpython3.8 libsqlite3-0 libstdc++-9-dev libxml2-dev libz3-dev pkg-config tzdata unzip zlib1g-dev
        ;;
    *)
        echo "Error: currently not supported version..." 1>&2
        exit 1
esac

# 1. Download binary release
if [ "${ARCH}" = "aarch64" ]; then
    URL_ARCH_APPEND="-${ARCH}"
else
    URL_ARCH_APPEND=""
fi
### URL example
### https://download.swift.org/swift-5.9.2-release/ubuntu2004/swift-5.9.2-RELEASE/swift-5.9.2-RELEASE-ubuntu20.04.tar.gz
### https://download.swift.org/swift-5.9.2-release/ubuntu2004-aarch64/swift-5.9.2-RELEASE/swift-5.9.2-RELEASE-ubuntu20.04-aarch64.tar.gz
URL_REGEXP="https://download\\.swift\\.org/.+ubuntu${MAJOR_VERSION}[0-9]+${URL_ARCH_APPEND}/.+RELEASE.+\\.tar\\.gz"
LATEST_DOWNLOAD_URL=`curl --compressed -fsSL https://www.swift.org/download/ | grep -o -E "${URL_REGEXP}" | head -n 1`

if [ -z "${LATEST_DOWNLOAD_URL}" ]; then
    echo "Download url is not found..." 1>&2
    exit 1
fi

SWIFT_NAME=`basename "${LATEST_DOWNLOAD_URL}" .tar.gz`

curl -fSL "${LATEST_DOWNLOAD_URL}" -o "${SWIFT_NAME}.tar.gz"
curl -fsSL "${LATEST_DOWNLOAD_URL}.sig" -o "${SWIFT_NAME}.sig"

# 2. import PGP keys 
#    (if you are downloading swift pkg **for the first time**, 
#     skip this step if you have imported the keys in the past)
SWIFT_KEY_NAME="Swift"
gpg --list-keys "${SWIFT_KEY_NAME}" || curl -fsSL https://swift.org/keys/all-keys.asc | gpg --import -

# 3. Verify the PGP signature 
gpg --keyserver hkp://keyserver.ubuntu.com --refresh-keys "${SWIFT_KEY_NAME}"
gpg --verify "${SWIFT_NAME}.sig" || { echo "Failed to verfiy signature" 1>&2; exit 1; }

# 4. Extract the Archive
tar xzf "${SWIFT_NAME}.tar.gz"
SWIFT_DIR_NAME=$(basename $(dirname $(find . -type d -name "usr")))
if [ "${SWIFT_DIR_NAME}" = "." ]; then
    mkdir -m 755 "${SWIFT_NAME}"
    mv usr "${SWIFT_NAME}/usr"
    SWIFT_DIR_NAME="${SWIFT_NAME}"
fi
mv "${SWIFT_DIR_NAME}" "${INSTALL_DIR}/${SWIFT_DIR_NAME}"
if [ $? -ne 0 ]; then
    echo "Failed to install to \"${INSTALL_DIR}/${SWIFT_DIR_NAME}\"" 1>&2
    exit 1
fi

# 5. Add the Swift toolchain to your path as follows:
# export PATH="$PATH:${INSTALL_DIR}/${SWIFT_DIR_NAME}/usr/bin"
echo "export PATH=\"\$PATH:${INSTALL_DIR}/${SWIFT_DIR_NAME}/usr/bin\"" > /etc/profile.d/swift-tarball.sh
source /etc/profile

# clean up
rm -rf -- "${CURR_DIR}"
trap - EXIT
exit 0

# # Swift (Docker)
# sudo docker pull swift
# sudo docker run --privileged --interactive --tty --name swift-latest:latest /bin/bash
# sudo docker start swift-latest
# sudo docker attach swift-latest
