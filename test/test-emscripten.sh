#!/bin/bash

set -e

##
# Phase 1: build Halide generators for diffuse

export CMAKE_GENERATOR="Ninja"
export CMAKE_BUILD_TYPE="Release"

cmake -S . -B build/host
cmake --build build/host --target diffuse-halide_generators

##
# Switch to Emscripten toolchain

CMAKE_TOOLCHAIN_FILE="$(em-config EMSCRIPTEN_ROOT)/cmake/Modules/Platform/Emscripten.cmake"
export CMAKE_TOOLCHAIN_FILE

##
# Phase 2: build diffuse for emscripten

cmake -S . -B build/diffuse \
  -Ddiffuse-halide_generators_ROOT="$PWD/build/host" \
  -DHalide_TARGET=wasm-32-wasmrt-wasm_simd128-wasm_threads \
  -DCMAKE_FIND_ROOT_PATH_MODE_PACKAGE=BOTH
cmake --build build/diffuse --verbose
cmake --install build/diffuse --prefix _local

##
# Phase 3: build the SDL app for emscripten

export CMAKE_PREFIX_PATH="$PWD/_local"

cmake -S apps/sdl -B build/sdl -DCMAKE_FIND_ROOT_PATH_MODE_PACKAGE=BOTH
cmake --build build/sdl --verbose
