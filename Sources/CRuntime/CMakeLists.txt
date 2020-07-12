add_library(CRuntime STATIC 
  dummy.c)

target_include_directories(CRuntime PUBLIC
  include)