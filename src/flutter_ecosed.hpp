#include <iostream>

#if _WIN32
#include <windows.h>
#else
#include <pthread.h>
#include <unistd.h>
#endif

// 内核模块结构体
typedef struct
{
    // 模块的通道名称,唯一标识符
    const char channel;
    // 模块标题
    const char title;
    // 模块描述
    const char description;
    // 模块作者
    const char author;
} EcosedKernelModule;

// 内核初始化
void kernel_init();