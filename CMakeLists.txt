cmake_minimum_required(VERSION 3.26)
project(
    diffuse
    VERSION 0.1.0
    LANGUAGES CXX
)

##
# Standard CMake modules

include(CMakeDependentOption)

if (PROJECT_IS_TOP_LEVEL)
    include(CTest)
endif ()

##
# Project-wide options

cmake_dependent_option(
    diffuse_BUILD_TESTING "When enabled, build tests for diffuse" ON
    "BUILD_TESTING" ON
)

# It should be as simple as setting the value of CMAKE_SKIP_INSTALL_RULES to the value
# of diffuse_SKIP_INSTALL_RULES, if defined. But the variable is extremely noisy.
# See: https://gitlab.kitware.com/cmake/cmake/-/issues/22561
cmake_dependent_option(
    diffuse_SKIP_INSTALL_RULES "When enabled, skips install rules for diffuse targets" OFF
    "NOT CMAKE_SKIP_INSTALL_RULES" ON
)

option(diffuse_BUILD_APPS "When enabled, build the demo apps for diffuse" NO)

##
# Override CMake defaults
set(
    CMAKE_CXX_VISIBILITY_PRESET hidden
    CACHE STRING "Value for the -fvisibility flag on supported compilers."
)

option(CMAKE_VISIBILITY_INLINES_HIDDEN "When enabled, hide inline symbols" YES)

# CMAKE_STATIC_LIBRARY_PREFIX is a *normal* variable, set by the
# platform module, so simply setting a cache variable (either here,
# at the command line, or in a preset) does not work. Instead, we
# offer a project option to disable overriding it if doing so causes
# problems. Because it is typically benign and helpful to downstreams,
# we enable it by default.
cmake_dependent_option(
    diffuse_OVERRIDE_STATIC_PREFIX "When enabled, set CMAKE_STATIC_LIBRARY_PREFIX to 'lib'" ON
    "CMAKE_IMPORT_LIBRARY_SUFFIX" OFF
)
mark_as_advanced(diffuse_OVERRIDE_STATIC_PREFIX)

if (diffuse_OVERRIDE_STATIC_PREFIX)
    # This resolves the name clash between the import library
    # (X.dll + X.lib) and the static library (also X.lib) by
    # changing the static library convention to libX.lib.
    # See: https://gitlab.kitware.com/cmake/cmake/-/issues/17338
    # See: https://cmake.org/Bug/view.php?id=10190
    # See: https://stackoverflow.com/q/2140129/2137996
    set(CMAKE_STATIC_LIBRARY_PREFIX "lib")
endif ()

##
# Dependencies

find_package(HalideHelpers 16 REQUIRED)

##
# Halide pipelines

add_halide_generator(
    diffuse_generator
    SOURCES src/reaction_diffusion_generator.cpp
)

add_halide_library(reaction_diffusion_init FROM diffuse_generator)

add_halide_library(
    reaction_diffusion_update FROM diffuse_generator
    USE_RUNTIME reaction_diffusion_init.runtime
)

add_halide_library(
    reaction_diffusion_render FROM diffuse_generator
    USE_RUNTIME reaction_diffusion_init.runtime
)

##
# Main diffuse library

## Create the target and apply export boilerplate
add_library(diffuse_diffuse)
add_library(diffuse::diffuse ALIAS diffuse_diffuse)
set_target_properties(
    diffuse_diffuse
    PROPERTIES
    OUTPUT_NAME diffuse
    EXPORT_NAME diffuse
    VERSION ${diffuse_VERSION}
    SOVERSION ${diffuse_VERSION_MAJOR}
)

## Set language level
target_compile_features(diffuse_diffuse PRIVATE cxx_std_17)

## Create export header

# Note: the complexity here is working around a bug (or missing feature)
# in CMake where generate_export_header is unnecessarily sensitive to the
# library type.
# See: https://gitlab.kitware.com/cmake/cmake/-/issues/23195

if (BUILD_SHARED_LIBS)
    set(type "shared")
else ()
    set(type "static")
    target_compile_definitions(diffuse_diffuse PUBLIC DIFFUSE_STATIC_DEFINE)
endif ()

include(GenerateExportHeader)
generate_export_header(
    diffuse_diffuse
    BASE_NAME diffuse
    EXPORT_FILE_NAME include/diffuse/export-${type}.h
)

## Attach sources
target_sources(diffuse_diffuse PRIVATE src/diffuse.cpp)
target_sources(
    diffuse_diffuse
    PUBLIC
    FILE_SET HEADERS
    BASE_DIRS include "${CMAKE_CURRENT_BINARY_DIR}/include"
    FILES
    include/diffuse/diffuse.h
    include/diffuse/export.h
    "${CMAKE_CURRENT_BINARY_DIR}/include/diffuse/export-${type}.h"
)

## Attach dependencies
target_link_libraries(
    diffuse_diffuse
    PRIVATE
    reaction_diffusion_init
    reaction_diffusion_update
    reaction_diffusion_render
)

##
# Include optional components

if (diffuse_BUILD_APPS)
    add_subdirectory(apps)
endif ()

if (diffuse_BUILD_TESTING)
    add_subdirectory(test)
endif ()

if (NOT diffuse_SKIP_INSTALL_RULES)
    add_subdirectory(packaging)
endif ()
