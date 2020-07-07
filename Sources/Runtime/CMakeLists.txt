add_subdirectory(CRuntime)

add_library(Runtime 
  Factory/DefaultValues.swift
  Factory/Factory.swift
  Layouts/ClassHeader.swift
  Layouts/ClassMetadataLayout.swift
  Layouts/ClassTypeDescriptor.swift
  Layouts/EnumMetadataLayout.swift
  Layouts/EnumTypeDescriptor.swift
  Layouts/ExistentialContainer.swift
  Layouts/FieldDescriptor.swift
  Layouts/FunctionMetadataLayout.swift
  Layouts/MetadataLayoutType.swift
  Layouts/ProtocolDescriptor.swift
  Layouts/ProtocolMetadataLayout.swift
  Layouts/ProtocolTypeContainer.swift
  Layouts/StructMetadataLayout.swift
  Layouts/StructTypeDescriptor.swift
  Layouts/TargetTypeGenericContextDescriptorHeader.swift
  Layouts/TupleMetadataLayout.swift
  Layouts/TypeDescriptor.swift
  Layouts/ValueWitnessTable.swift
  Metadata/ClassMetadata.swift
  Metadata/EnumMetadata.swift
  Metadata/FunctionMetadata.swift
  Metadata/NominalMetadata.swift
  Metadata/ProtocolMetadata.swift
  Metadata/StructMetadata.swift
  Metadata/TupleMetadata.swift
  Models/Case.swift
  Models/Errors.swift
  Models/FunctionInfo.swift
  Models/Kind.swift
  Models/PropertyInfo.swift
  Models/TypeInfo.swift
  Models/TypeInfoConvertible.swift
  Pointers/Pointers.swift
  Pointers/RelativePointers.swift
  Pointers/RelativeVectorPointer.swift
  Pointers/Union.swift
  Pointers/Vector.swift
  Utilities/GettersSetters.swift
  Utilities/Pointer+Extensions.swift
  Utilities/RetainCounts.swift
  Utilities/String+Extensions.swift)

target_compile_options(Runtime PRIVATE
  "SHELL:$<$<PLATFORM_ID:Windows>:-Xcc -D_CRT_SECURE_NO_WARNINGS>")
set_target_properties(Runtime PROPERTIES
  INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})

swift_install(TARGETS Runtime
  EXPORT Runtime)