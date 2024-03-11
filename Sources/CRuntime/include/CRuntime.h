#ifndef cruntime_h
#define cruntime_h

#include <stdlib.h>

const void * _Nullable swift_getTypeByMangledNameInContext(
                        const char * _Nullable typeNameStart,
                        int typeNameLength,
                        const void * _Nullable context,
                        const void * _Nullable const * _Nullable genericArgs);

const void * _Nullable swift_allocObject(
                    const void * _Nullable type,
                    size_t requiredSize,
                    size_t requiredAlignmentMask);

#endif
