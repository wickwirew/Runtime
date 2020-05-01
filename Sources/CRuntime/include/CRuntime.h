#ifndef cruntime_h
#define cruntime_h

#include <stddef.h>

__attribute__((swiftcall))
const void * _Nullable swift_getTypeByMangledNameInContext(
                        const char * _Nullable typeNameStart,
                        size_t typeNameLength,
                        const void * _Nullable context,
                        const void * _Nullable const * _Nullable genericArgs);

const void * _Nullable swift_allocObject(
                    void const* _Nullable type,
                    size_t requiredSize,
                    size_t requiredAlignmentMask);

#endif
