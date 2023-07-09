$ErrorActionPreference="Stop"

$env:CMAKE_GENERATOR="Ninja"
$env:CMAKE_BUILD_TYPE="Release"
$env:CMAKE_TOOLCHAIN_FILE=Resolve-Path .\vcpkg\scripts\buildsystems\vcpkg.cmake

# Clean up

if (test-path build) { rm -r -fo build }
if (test-path _local) { rm -r -fo _local }

# Library builds

cmake -S . -B build/shared -DBUILD_SHARED_LIBS=YES
cmake -S . -B build/static -DBUILD_SHARED_LIBS=NO

cmake --build build/shared
cmake --build build/static

cmake --install build/shared --prefix _local/shared
cmake --install build/shared --prefix _local/both

cmake --install build/static --prefix _local/static
cmake --install build/static --prefix _local/both

# App builds

$env:CMAKE_PREFIX_PATH=Resolve-Path .\_local\shared
cmake -S apps/sdl -B build/apps-shared
cmake --build build/apps-shared

$env:CMAKE_PREFIX_PATH=Resolve-Path .\_local\static
cmake -S apps/sdl -B build/apps-static
cmake --build build/apps-static

$env:CMAKE_PREFIX_PATH=Resolve-Path .\_local\both
cmake -S apps/sdl -B build/apps-both-static -Ddiffuse_SHARED_LIBS=NO
cmake --build build/apps-both-static

$env:CMAKE_PREFIX_PATH=Resolve-Path .\_local\both
cmake -S apps/sdl -B build/apps-both-shared -Ddiffuse_SHARED_LIBS=YES
cmake --build build/apps-both-shared
