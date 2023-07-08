cmake_minimum_required(VERSION 3.25)
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
