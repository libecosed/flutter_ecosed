// #include <cstdint>
// #include <cstdio>
// #include <cstdlib>

#ifdef __cplusplus
#include <cstdint>
#include <cstdio>
#include <cstdlib>
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
#define FFI_PLUGIN_EXPORT
#endif


//静态库文件的头文件代码
#ifdef __cplusplus          //检测是否为C++文件调用，若是则extern不起作用
extern "C" {
#endif

// A very short-lived native function.
//
// For very short-lived functions, it is fine to call them on the main isolate.
// They will block the Dart execution while running the native function, so
// only do this for native functions which are guaranteed to be short-lived.
//extern "C"
//__attribute__((visibility("default"))) __attribute__((used))
FFI_PLUGIN_EXPORT int sum(int a, int b);

// A longer lived native function, which occupies the thread calling it.
//
// Do not call these kind of native functions in the main isolate. They will
// block Dart execution. This will cause dropped frames in Flutter applications.
// Instead, call these native functions on a separate isolate.
//extern "C"
//__attribute__((visibility("default"))) __attribute__((used))
FFI_PLUGIN_EXPORT int sum_long_running(int a, int b);
	
#ifdef __cplusplus  
}
#endif



