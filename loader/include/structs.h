#include <memory>

struct DispatchTask;
struct __shared_weak_count;

typedef struct shared_ptr<DispatchTask> {
    struct DispatchTask *__ptr_;
    struct __shared_weak_count *__cntrl_;
} shared_ptr_3431538a;

struct Handle<std::shared_ptr<DispatchTask>, std::shared_ptr<DispatchTask> > {
    struct shared_ptr<djinni::ProxyCache<djinni::CppProxyCacheTraits>::Pimpl> m_cache;
    shared_ptr_3431538a m_obj;
};

