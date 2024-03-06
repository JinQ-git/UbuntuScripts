# Shell Script Tips

# 0.

## toLower

```sh
# 1. Using pipe `tr '[:upper:]' '[:lower:]'`
echo "Hello World" | tr '[:upper:]' '[:lower:]'

# 2. bash 4.0+ (non-posix)
TEXT="Hello World"
echo ${TEXT,,}
```

# 1. `root` user check

```sh
if [ "$UID" -ne "0" ]; then
  echo "Not 'root' user" 1>&2
  exit 1
fi
```

# 2. OS version check

## 2.1. via `/etc/os-release` file

> ref\> [https://www.freedesktop.org/software/systemd/man/latest/os-release.html](https://www.freedesktop.org/software/systemd/man/latest/os-release.html)

```sh
if [ -f "/etc/os-release" ]; then
    source /etc/os-release
elif [ -f "/usr/lib/os-release" ]; then
    source /usr/lib/os-release
fi

# NAME="Ubuntu"
# VERSION="20.04.3 LTS (Focal Fossa)"
# ID=ubuntu
# ID_LIKE=debian
# PRETTY_NAME="Ubuntu 20.04.3 LTS"
# VERSION_ID="20.04"
# (...omitted below...)
```

## 2.2 via `lsb_release` command

```sh
ID=`lsb_release -is | tr '[:upper:]' '[:lower:]'`
VERSION_ID=`lsb_release -sr`
PRETTY_NAME=`lsb_release -sd`

# ID=ubuntu
# VERSION_ID="20.04"
# PRETTY_NAME="Ubuntu 20.04.3 LTS"
```

## Major Version Test

```sh
# VERSION_ID="20.04"
# NOTE: return `major version` if `major version >= 18`, otherwise return `0`
MAJOR_VERSION=`echo "${VERSION_ID}" | awk '{ print $0 ~ /^[0-9]+(\.[0-9]+)*$/ && int($0) >= 18 ? int($0) : 0 }'`
if [ "${MAJOR_VERSION}" -eq "0" ]; then 
    echo "18.04+ is required: [${VERSION_ID}]" 1>&2
    exit 1
fi
```

# 3. Machine Architecture Check

```sh
ARCH=`uname -m | tr '[:upper:]' '[:lower:]'` # x86_64, aarch64 \\ i386, i686 not support
# uname -m: machine hardware name
# uname -i: hardware platform

# aarch64: ARM 64bit
if [ "${ARCH}" != "x86_64" -a "${ARCH}" != "aarch64" ]; then
    echo "Target Platform must be one of [x86_64 or aarch64]: [${ARCH}]" 1>&2
    exit 1
if
```

