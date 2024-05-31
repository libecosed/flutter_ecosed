#include "flutter_ecosed.h"
#include "flutter_ecosed.hpp"

extern "C" FFI_PLUGIN_EXPORT void init()
{
  return kernel_init();
}

using namespace std;
int main()
{
  return 0;
}

void kernel_init() {
  
}