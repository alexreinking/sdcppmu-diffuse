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
# Include project sources

add_subdirectory(src)

if (diffuse_BUILD_APPS)
    add_subdirectory(apps)
endif ()

if (diffuse_BUILD_TESTING)
    add_subdirectory(test)
endif ()

if (NOT diffuse_SKIP_INSTALL_RULES)
    add_subdirectory(packaging)
endif ()
