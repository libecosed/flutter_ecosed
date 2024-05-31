#include "flutter_ecosed.h"
#include "flutter_ecosed.hpp"

//--------------------------------------------------------------

extern "C" FFI_PLUGIN_EXPORT void init()
{
  return kernel_init();
}

extern "C" FFI_PLUGIN_EXPORT char list()
{
  return kernel_module_list();
}

//--------------------------------------------------------------

using namespace std;
int main()
{
  cout << "kernel start." << endl;
  kernel_init();

  cout << kernel_module_list() << endl;

  int intArray[] = {1, 2, 3, 4, 5};
  
  cout << "kernel end." << endl;
  return 0;
}

void kernel_init()
{
}

char kernel_module_list()
{
  return 1;
}