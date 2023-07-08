set(version 16.0.0)
set(commit 1e963ff817ef0968cc25d811a25a7350c8953ee6)

set(sha512_arm-32-linux 0)
set(sha512_arm-64-linux 0)
set(sha512_arm-64-osx 0)
set(sha512_x86-32-linux 0)
set(sha512_x86-32-windows 0)
set(sha512_x86-64-linux 0)
set(sha512_x86-64-osx 0)
set(sha512_x86-64-windows b4ae69d9efa4b7bbe4feb71be8920d458bc5baa45c31de20fc649563dd456fe99a0f3cf0ad452188f5b55c957fa27545a0ff6a7239004ac2a188038a3c3c5300)

# triplet selection is documented here:
# https://learn.microsoft.com/en-us/vcpkg/users/triplets

set(arch unknown)
set(bits unknown)
set(os unknown)

if (VCPKG_TARGET_ARCHITECTURE MATCHES "^x(86|64)$")
    set(arch x86)
endif ()

if (VCPKG_TARGET_ARCHITECTURE MATCHES "^arm")
    set(arch arm)
endif ()

if (VCPKG_TARGET_ARCHITECTURE MATCHES "64$")
    set(bits 64)
else ()
    set(bits 32)
endif ()

if (VCPKG_TARGET_IS_LINUX)
    set(os linux)
elseif (VCPKG_TARGET_IS_OSX)
    set(os osx)
elseif (VCPKG_TARGET_IS_WINDOWS)
    set(os windows)
endif ()

if (arch STREQUAL "unknown" OR bits STREQUAL "unknown" OR os STREQUAL "unknown")
    message(FATAL_ERROR "No binaries available for ${arch}-${bits}-${os}")
endif ()

set(halide_triple ${arch}-${bits}-${os})

if (os STREQUAL "windows")
    set(ext "zip")
else ()
    set(ext "tar.gz")
endif ()

set(filename Halide-${version}-${halide_triple}-${commit}.${ext})

vcpkg_download_distfile(
    halide_archive
    URLS https://github.com/halide/Halide/releases/download/v${version}/${filename}
    FILENAME ${filename}
    SHA512 ${sha512_${halide_triple}}
)

vcpkg_extract_source_archive(
    halide_binaries
    ARCHIVE "${halide_archive}"
)

file(
    INSTALL "${halide_binaries}/"
    DESTINATION "${CURRENT_INSTALLED_DIR}"
    PATTERN "share/doc" EXCLUDE
)
