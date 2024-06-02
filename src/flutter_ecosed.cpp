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

  cout << "kernel end." << endl;
  return 0;
}

void kernel_init()
{
  cout << kernel_module_list() << endl;
}

char kernel_module_list()
{
  return 'a';
}