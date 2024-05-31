#ifdef __cplusplus
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <iostream>
#endif

#if _WIN32
#include <windows.h>
#else
#include <pthread.h>
#include <unistd.h>
#endif

#if _WIN32
#define FFI_PLUGIN_EXPORT __declspec(dllexport)
#else
#define FFI_PLUGIN_EXPORT __attribute__((visibility("default"))) __attribute__((used))
#endif

#ifdef __cplusplus
extern "C"
{
#endif

    FFI_PLUGIN_EXPORT void init();
    // FFI_PLUGIN_EXPORT int sum(int a, int b);
    // FFI_PLUGIN_EXPORT int sum_long_running(int a, int b);

#ifdef __cplusplus
}
#endif


typedef struct {
    const char name;
    const int age;
} EcosedKernelModule;


void kernel_init();