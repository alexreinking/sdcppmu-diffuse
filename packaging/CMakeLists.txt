include(GNUInstallDirs)

set(diffuse_INSTALL_CMAKEDIR "${CMAKE_INSTALL_LIBDIR}/cmake/diffuse"
    CACHE STRING "Relative path beneath install prefix to place CMake package files")

if (BUILD_SHARED_LIBS)
    set(type shared)
    set(extra_targets "")
else ()
    set(type static)

    # The extra deps here are always static. Therefore, they are
    # subsumed by the shared library in that configuration, but
    # are dependencies of the static library, and must be installed
    # too.
    set(
        extra_targets
        reaction_diffusion_init
        reaction_diffusion_update
        reaction_diffusion_render
        reaction_diffusion_init.runtime
    )
endif ()

install(
    TARGETS diffuse_diffuse ${extra_targets}
    EXPORT diffuse-${type}-targets
    RUNTIME COMPONENT diffuse-runtime
    LIBRARY COMPONENT diffuse-runtime NAMELINK_COMPONENT diffuse-development
    ARCHIVE COMPONENT diffuse-development
    FILE_SET HEADERS COMPONENT diffuse-development
)

install(
    EXPORT diffuse-${type}-targets
    DESTINATION "${diffuse_INSTALL_CMAKEDIR}"
    NAMESPACE diffuse::
    COMPONENT diffuse-development
)

include(CMakePackageConfigHelpers)

configure_package_config_file(
    diffuse-config.cmake.in diffuse-config.cmake
    INSTALL_DESTINATION "${diffuse_INSTALL_CMAKEDIR}"
)

write_basic_package_version_file(
    diffuse-config-version.cmake
    COMPATIBILITY ExactVersion
)

install(
    FILES
    "${CMAKE_CURRENT_BINARY_DIR}/diffuse-config.cmake"
    "${CMAKE_CURRENT_BINARY_DIR}/diffuse-config-version.cmake"
    "${CMAKE_CURRENT_SOURCE_DIR}/diffuse-${type}-deps.cmake"
    DESTINATION "${diffuse_INSTALL_CMAKEDIR}"
    COMPONENT diffuse-development
)
