#ifndef cruntime_h
#define cruntime_h

#include <stddef.h>

const void * _Nullable swift_allocObject(
                    void const* _Nullable type,
                    size_t requiredSize,
                    size_t requiredAlignmentMask);

#endif
