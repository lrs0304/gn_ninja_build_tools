#!/usr/bin/env bash

echo "prepare docker build environment"
uname -a

cd $(dirname "$0")
script_path=`pwd`
echo "curren dir = ${script_path}" 

echo "clone gn from github"
echo "commit id is from skia/bin; use command: gn --version"
git clone https://github.com/lrs0304/gn.git
cd gn
git checkout 9e993e3d

echo "install ninja and gcc 11"
yum -y install ninja-build
yum -y install scl-utils
yum -y install centos-release-scl
yum -y install devtoolset-11-gcc devtoolset-11-gcc-c++ devtoolset-11-binutils

echo "use system environment to replace clang with g++"
export CXX=g++

echo "start build in ${script_path}"
chmod +x ${script_path}/build_gn.sh
scl enable devtoolset-11 ${script_path}/build_gn.sh