find_package(SDL2 REQUIRED)

add_executable(demo_app main.cpp)
target_link_libraries(
    demo_app
    PRIVATE
    diffuse::diffuse
    SDL2::SDL2main
    SDL2::SDL2
)
target_compile_features(demo_app PRIVATE cxx_std_17)
