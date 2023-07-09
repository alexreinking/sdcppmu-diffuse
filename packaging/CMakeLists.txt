include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

if (BUILD_SHARED_LIBS)
    set(type shared)
    set(extra_targets "")
    set(dependencies "")
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

    set(dependencies HalideHelpers)
endif ()

install(
    TARGETS diffuse_diffuse ${extra_targets}
    EXPORT diffuse-${type}-targets
    RUNTIME COMPONENT diffuse-runtime
    LIBRARY COMPONENT diffuse-runtime NAMELINK_COMPONENT diffuse-development
    ARCHIVE COMPONENT diffuse-development
    FILE_SET HEADERS COMPONENT diffuse-development
)

set(diffuse_INSTALL_CMAKEDIR "${CMAKE_INSTALL_LIBDIR}/cmake/diffuse"
    CACHE STRING "Relative path beneath install prefix to place CMake package files")

install(
    EXPORT diffuse-${type}-targets
    DESTINATION "${diffuse_INSTALL_CMAKEDIR}"
    NAMESPACE diffuse::
    COMPONENT diffuse-development
)

if (dependencies)
    file(
        CONFIGURE
        OUTPUT diffuse-${type}-deps.cmake
        CONTENT [[
set(dependencies "@dependencies@")
foreach (dep IN LISTS dependencies)
    find_dependency(${dep})
endforeach ()
]]
        @ONLY
    )
    install(
        FILES "${CMAKE_CURRENT_BINARY_DIR}/diffuse-${type}-deps.cmake"
        DESTINATION "${diffuse_INSTALL_CMAKEDIR}"
        COMPONENT diffuse-development
    )
endif ()

configure_package_config_file(
    diffuse-config.cmake.in diffuse-config.cmake
    INSTALL_DESTINATION "${diffuse_INSTALL_CMAKEDIR}"
    NO_SET_AND_CHECK_MACRO
    NO_CHECK_REQUIRED_COMPONENTS_MACRO
)

write_basic_package_version_file(
    diffuse-config-version.cmake
    COMPATIBILITY ExactVersion
)

install(
    FILES
    "${CMAKE_CURRENT_BINARY_DIR}/diffuse-config.cmake"
    "${CMAKE_CURRENT_BINARY_DIR}/diffuse-config-version.cmake"
    DESTINATION "${diffuse_INSTALL_CMAKEDIR}"
    COMPONENT diffuse-development
)
