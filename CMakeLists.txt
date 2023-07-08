cmake_minimum_required(VERSION 3.25)
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

cmake_dependent_option(
    diffuse_SKIP_INSTALL_RULES "When enabled, skips install rules for diffuse targets" OFF
    "NOT CMAKE_SKIP_INSTALL_RULES" ON
)

option(diffuse_BUILD_APPS "When enabled, build the demo apps for diffuse" "${PROJECT_IS_TOP_LEVEL}")

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
add_halide_library(reaction_diffusion_update FROM diffuse_generator)
add_halide_library(reaction_diffusion_render FROM diffuse_generator)

##
# Main diffuse library

add_library(diffuse_diffuse)
add_library(diffuse::diffuse ALIAS diffuse_diffuse)

target_sources(diffuse_diffuse PRIVATE src/diffuse.cpp)
target_sources(
    diffuse_diffuse
    PUBLIC
    FILE_SET HEADERS
    BASE_DIRS include
    FILES include/diffuse/diffuse.h
)

target_compile_features(diffuse_diffuse PRIVATE cxx_std_17)

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
