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
    FFI_PLUGIN_EXPORT char list();
#ifdef __cplusplus
}
#endif