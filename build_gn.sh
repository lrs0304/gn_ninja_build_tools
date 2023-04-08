#!/usr/bin/env bash

echo "start builg gn project"
cd $(dirname "$0")
pwd

echo "clone gn from github"
git clone https://github.com/lrs0304/gn.git
if [ $? -ne 0 ]; then
	exit -1
fi

echo "checkout to target commit id, commit id is from skia/bin; use command: gn --version"
cd gn
git checkout 9e993e3d

echo "use system environment to replace clang with g++"
export CXX=g++

echo "generate build project"
python3 build/gen.py

echo "start build"
ninja-build --version
ninja-build -C out/

echo "package gn"
cd out
zip gn.zip ./gn