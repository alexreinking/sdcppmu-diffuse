# allow non-standard package layout
set(VCPKG_POLICY_EMPTY_PACKAGE enabled)

set(version 16.0.0)
set(commit 1e963ff817ef0968cc25d811a25a7350c8953ee6)

set(sha512_arm-32-linux 69e2140e5de16624a6ed1dd49a7999dc2802768fe3bfea392d21a5e4a0454d88fef40c09de515fddfbb8f35b5bd87d977da5d96f2c1c1715030017d3e8b664a8)
set(sha512_arm-64-linux fa58bdef45998bb00d790c4c1bc54be66586ac0a762cbeddd9ab0d749310d91e9fdbffe9360b652a413341320b47393539ca0d30cf74b146b227aaaaecff0fd9)
set(sha512_arm-64-osx 332a02d3d547a98eb1f44000811a229bd3c25292fe3290eb0aba8e102e295f3804565dbd70fb16f0b89eef7c584f681f67d928a67414e325c2f5b21fc907df50)
set(sha512_x86-32-linux 7d39090c398878e1f5ef1a0e216c614f907a15e998bfa84b388f7cd89d9929f565fc800546cf85228a832609fce1afc57ef0115b38ccd34914956ae2c23a9679)
set(sha512_x86-32-windows b1901dac0da81e3c3cdab3ce6556f967cf0f4214f720c90709b218df35d13eb036d7c79feae23008d367eb2e223c180780fbe25ed433b6a37beae51652729f99)
set(sha512_x86-64-linux 85f62d58a8cb06433eae7b88a50aacda8061774c7e37ea49d541ab08b395e0f4c84926b91c767244336eb2b32d538693fa06d35694ad839a99ce5a23d3435f20)
set(sha512_x86-64-osx ebf3edfaa117feacef04c2fa14ce92dc40aed83c8b1a7080afc2ee09494ec8878e764e239b5c8323e4542c9f3164f86747ecf5925dc08e0c10b1397f83176009)
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
    DESTINATION "${CURRENT_PACKAGES_DIR}"
    PATTERN "share/doc" EXCLUDE
)
