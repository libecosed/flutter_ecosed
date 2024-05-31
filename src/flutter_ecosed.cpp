#include "flutter_ecosed.h"

int main() {

  return 0;
}

extern "C" FFI_PLUGIN_EXPORT int sum(int a, int b)
{
  return a + b;
}

extern "C" FFI_PLUGIN_EXPORT int sum_long_running(int a, int b)
{
  // Simulate work.
#if _WIN32
  Sleep(5000);
#else
  usleep(5000 * 1000);
#endif
  return a + b;
}