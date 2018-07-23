// MIT License
//
// Copyright (c) 2017 Wesley Wickwire
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation



protocol NominalMetadataType: MetadataType where Layout: NominalMetadataLayoutType {
    init(type: Any.Type, metadata: UnsafeMutablePointer<Layout>, nominalTypeDescriptor: UnsafeMutablePointer<NominalTypeDescriptor>, base: UnsafeMutablePointer<Int>)
    var nominalTypeDescriptor: UnsafeMutablePointer<NominalTypeDescriptor> { get set }
}

extension NominalMetadataType {
    
    init(type: Any.Type, metadata: UnsafeMutablePointer<Layout>, base: UnsafeMutablePointer<Int>) {
        self.init(type: type, metadata: metadata, nominalTypeDescriptor: metadata.pointee.nominalTypeDescriptor, base: base)
    }
    
    mutating func mangledName() -> String {
        return String(cString: nominalTypeDescriptor.pointee.mangledName.advanced())
    }
    
    mutating func numberOfFields() -> Int {
        return nominalTypeDescriptor.pointee.numberOfFields.getInt()
    }
    
    mutating func fieldOffsets() -> [Int] {
        return nominalTypeDescriptor.pointee.offsetToTheFieldOffsetVector.vector(metadata: base, n: numberOfFields()).map{ Int($0) }
    }
    
    mutating func genericParameterCount() -> Int {
        return nominalTypeDescriptor.pointee.exclusiveGenericParametersCount.getInt()
    }
    
    mutating func genericParameters() -> [Any.Type] {
        return nominalTypeDescriptor.pointee.genericParameterVector.vector(metadata: base, n: genericParameterCount())
    }
    
    mutating func properties() -> [PropertyInfo] {
        let offsets = fieldOffsets()
        
        return (0..<offsets.count).map{ index in
            let offset = offsets[index]
            var context = PropertyInfoContext(name: "", type: Any.self)
            _getFieldAt(type, index, { name, type, ctx in
                let infoContext = ctx.assumingMemoryBound(to: PropertyInfoContext.self).mutable
                infoContext.pointee = PropertyInfoContext(
                    name: String(cString: name),
                    type: unsafeBitCast(type, to: Any.Type.self)
                )
            }, &context)
            return PropertyInfo(name: context.name, type: context.type, offset: offset, ownerType: type)
        }
    }
    
    mutating func toTypeInfo() -> TypeInfo {
        var info = TypeInfo(nominalMetadata: self)
        info.properties = properties()
        return info
    }
}

@_silgen_name("swift_getFieldAt")
func _getFieldAt(
    _ type: Any.Type,
    _ index: Int,
    _ callback: @convention(c) (UnsafePointer<CChar>, UnsafeRawPointer, UnsafeRawPointer) -> Void,
    _ ctx: UnsafeRawPointer
)

/// Type to use as the context in the `_getFieldAt` function.
fileprivate struct PropertyInfoContext {
    let name: String
    let type: Any.Type
}
