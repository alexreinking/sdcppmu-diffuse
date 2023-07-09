include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

if (BUILD_SHARED_LIBS)
    set(type shared)
    set(extra_deps "")
else ()
    set(type static)
    set(
        extra_deps
        reaction_diffusion_init
        reaction_diffusion_update
        reaction_diffusion_render
        reaction_diffusion_init.runtime
    )
endif ()

install(
    TARGETS diffuse_diffuse ${extra_deps}
    EXPORT diffuse-${type}
    RUNTIME COMPONENT diffuse-runtime
    LIBRARY COMPONENT diffuse-runtime NAMELINK_COMPONENT diffuse-development
    ARCHIVE COMPONENT diffuse-development
    FILE_SET HEADERS COMPONENT diffuse-development
)

set(diffuse_INSTALL_CMAKEDIR "${CMAKE_INSTALL_LIBDIR}/cmake/diffuse"
    CACHE STRING "Relative path beneath install prefix to place CMake package files")

install(
    EXPORT diffuse-${type}
    DESTINATION "${diffuse_INSTALL_CMAKEDIR}"
    NAMESPACE diffuse::
    COMPONENT diffuse-development
)