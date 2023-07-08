cmake_minimum_required(VERSION 3.25)
project(diffuse_apps NONE)

##
# When building in-tree, we don't want the apps to do a real
# call to find_package(diffuse REQUIRED)

file(
    CONFIGURE
    OUTPUT cmake/Finddiffuse.cmake
    CONTENT [[ set(diffuse_FOUND 1) ]]
)

list(PREPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_BINARY_DIR}/cmake")

##
# Add the apps

add_subdirectory(sdl)
