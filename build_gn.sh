#!/usr/bin/env bash

echo "generate project"
cd $(dirname "$0")
cd gn
python build/gen.py

echo "start build"
ninja-build -C out/