# Ubuntu Init. Script

# 1. ubuntu_init.sh

## 1.1. Basic Packages

> **NOTE:** If you use the default installation option, most of the following packages might already be installed.

- `ca-certificates`
- `openssh-server`
- `curl`
- `vim`
- `net-tools`
- `tmux`
- `man-db` `manpages-posix` `manpages-dev` `manpages-posix-dev`
   > **NOTE**: The "minimized" Ubuntu: `unminimize` command first for `man`

```sh
sudo apt-get update && sudo apt-get install -y ca-certificates openssh-server curl vim net-tools tmux

# Skip `man-db` package on "Minimized" Ubuntu
if [ ! -e "/etc/dpkg/dpkg.cfg.d/excludes" ]; then
    sudo apt-get install man-db manpages-posix manpages-dev manpages-posix-dev
fi
```

## 1.2. Basic Development Packages

- `build-essesntial`
- `ninja-build`
- `cmake`
- `python3-pip`
- openjdk
- dotnet: [https://learn.microsoft.com/ko-kr/dotnet/core/install/linux-ubuntu-2204](https://learn.microsoft.com/ko-kr/dotnet/core/install/linux-ubuntu-2204)

> **NOTE:**
> |             | Ubuntu 18 | Ubuntu 20 | Ubuntu 22 |
> |:-----------:|:---------:|:---------:|:---------:|
> | **openjdk** | 8, 11, **17** | 8, 11, 17, 18, 19, **21** | 8, 11, 17, 18, 19, **21** |
> | **dotnet**  | 6, 7      | 6, 7, 8   | 6, 7, 8   |
> 
> \*\* _`defaultjdk`_ is 11 (for all version, 2024.03)

```sh
sudo apt-get install -y build-essential ninja-build cmake python3-pip
```

### for Ubuntu 18.x

```sh
sudo apt-get install -y openjdk-17-jdk dotnet-sdk-7.0
```

### for Ubuntu 20.x, Ubuntu 22.x

```sh
sudo apt-get install -y openjdk-21-jdk dotnet-sdk-8.0
```

## 1.3. Additional Tools

### 1.3.0 Rust

> **NOTE:** this method is for a single user.

```sh
curl -fsSL https://get.docker.com | sudo -E bash -
```

### 1.3.1. LLVM (clang) - latest

```sh
curl -fsSL https://apt.llvm.org/llvm.sh | sudo -E bash -s -- all
```

> **NOTE:**
> For convenience there is an automatic installation script available that installs LLVM for you.<br/>
> To install the latest stable version:
> ```sh
> bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)"
> ```
> To install a specific version of LLVM:
> ```sh
> wget https://apt.llvm.org/llvm.sh
> chmod +x llvm.sh
> sudo ./llvm.sh ${Version_Number}
> ```
> To install all apt.llvm.org packages at once:
> ```sh
> wget https://apt.llvm.org/llvm.sh
> chmod +x llvm.sh
> sudo ./llvm.sh <version number> all
> # or
> sudo ./llvm.sh all
> ```

### 1.3.2. node.js - LTS

```sh
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - && sudo apt-get install -y nodejs
```

> **NOTE:** `setup_lts.x` add repo. and key: `/etc/apt/sources.list.d/nodesource.list` and `/etc/apt/keyrings/nodesource.gpg`

### 1.3.3. Docker

```sh
curl -fsSL https://get.docker.com | sudo -E bash -
```
