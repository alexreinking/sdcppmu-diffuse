##
# Dependencies

find_package(HalideHelpers 16 REQUIRED)

##
# Halide pipelines

add_halide_generator(
    diffuse_generator
    SOURCES reaction_diffusion_generator.cpp
)

add_halide_library(reaction_diffusion_init FROM diffuse_generator)
add_halide_library(reaction_diffusion_update FROM diffuse_generator)
add_halide_library(reaction_diffusion_render FROM diffuse_generator)

##
# Main diffuse library

add_library(diffuse_diffuse)
add_library(diffuse::diffuse ALIAS diffuse_diffuse)

target_sources(diffuse_diffuse PRIVATE diffuse.cpp)
target_sources(
    diffuse_diffuse
    PUBLIC
    FILE_SET HEADERS
    BASE_DIRS "${PROJECT_SOURCE_DIR}/include"
    FILES "${PROJECT_SOURCE_DIR}/include/diffuse/diffuse.h"
)

target_compile_features(diffuse_diffuse PRIVATE cxx_std_17)

target_link_libraries(
    diffuse_diffuse
    PRIVATE
    reaction_diffusion_init
    reaction_diffusion_update
    reaction_diffusion_render
)
