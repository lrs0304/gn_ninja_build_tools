#!/usr/bin/env bash

echo "prepare docker build environment"
uname -a


echo "clone gn"
git clone https://github.com/lrs0304/gn.git
cd gn
git checkout 2023.03

echo "install gcc 11"
yum -y install scl-utils
yum -y install centos-release-scl
yum -y install devtoolset-11-gcc devtoolset-11-gcc-c++ devtoolset-11-binutils

echo "replace clang to cxx"
sed -i 's#or platform.is_mingw():#or platform.is_mingw() or platform.is_linux():#g' build/gen.py
git status

echo "start build"
script_path=$(dirname "$0")
scl enable devtoolset-11 ${script_path}/build_gn.sh