#!/usr/bin/env bash

echo "generate project"
python build/gen.py

echo "start build"
./ninja -C out/