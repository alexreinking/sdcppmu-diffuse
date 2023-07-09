cmake_minimum_required(VERSION 3.26)
project(diffuse_sdl LANGUAGES CXX)

find_package(SDL2 REQUIRED)
find_package(diffuse REQUIRED)

add_executable(diffuse_sdl main.cpp)
target_link_libraries(
    diffuse_sdl
    PRIVATE
    SDL2::SDL2main
    SDL2::SDL2
    diffuse::diffuse
)
target_compile_features(diffuse_sdl PRIVATE cxx_std_17)

# TODO: see if presets will let us set the PATH or
#   if some value of CMAKE_RUNTIME_OUTPUT_DIRECTORY
#   works to place them together no matter what.
if (CMAKE_IMPORT_LIBRARY_SUFFIX)
    # The -t flag below was introduced in CMake 3.26
    # https://gitlab.kitware.com/cmake/cmake/-/issues/23543
    add_custom_command(
        TARGET diffuse_sdl
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy -t $<TARGET_FILE_DIR:diffuse_sdl> $<TARGET_RUNTIME_DLLS:diffuse_sdl>
        COMMAND_EXPAND_LISTS
    )
endif ()
