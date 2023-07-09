include(GNUInstallDirs)

if (BUILD_SHARED_LIBS)
    set(type shared)
else ()
    set(type static)
endif ()

install(
    TARGETS diffuse_diffuse
    EXPORT diffuse-${type}
    RUNTIME COMPONENT diffuse-runtime
    LIBRARY COMPONENT diffuse-runtime NAMELINK_COMPONENT diffuse-development
    ARCHIVE COMPONENT diffuse-development
    FILE_SET HEADERS COMPONENT diffuse-development
)