# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(flutter_ecosed_library LANGUAGES C CXX)

add_library(flutter_ecosed SHARED
  "flutter_ecosed.cpp"
  "main.cpp"
)

add_executable(
  kernel
  "main.cpp"
)

set_target_properties(flutter_ecosed PROPERTIES
  PUBLIC_HEADER flutter_ecosed.h
  OUTPUT_NAME "flutter_ecosed"
)

target_compile_definitions(flutter_ecosed PUBLIC DART_SHARED_LIB)

if (ANDROID)
    find_library(log-lib log)
endif (ANDROID)