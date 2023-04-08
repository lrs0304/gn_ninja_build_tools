#!/usr/bin/env bash

echo "prepare docker build environment"
uname -a

cd $(dirname "$0")
script_path=`pwd`
echo "curren dir = ${script_path}" 
chmod +x ${script_path}/build_gn.sh

echo "install ninja"
yum -y install ninja-build

echo "test gcc 11 or install gcc11"
gcc --version
gcc --version | grep -q "gcc (.*[[:space:]])\?11\."
if [ $? -eq 0 ]; then
	bash ${script_path}/build_gn.sh
	exit $?
else
	echo "current GCC version is less than 10"
fi

echo "try install gcc-toolset-11"
yum -y install gcc-toolset-11
if [[ "$?" -eq "0" ]];then
	yum -y install centos-release-scl
	scl enable gcc-toolset-11 ${script_path}/build_gn.sh
else
	echo "support centos-release-scl"
	yum -y install scl-utils
	yum -y install devtoolset-11-gcc devtoolset-11-gcc-c++ devtoolset-11-binutils
	scl enable devtoolset-11 ${script_path}/build_gn.sh
fi