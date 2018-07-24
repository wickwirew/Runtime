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



struct EnumMetadata: MetadataType {
    
    var type: Any.Type
    var metadata: UnsafeMutablePointer<EnumMetadataLayout>
    var nominalTypeDescriptor: UnsafeMutablePointer<StructTypeDescriptor>
    var base: UnsafeMutablePointer<Int>
    
    init(type: Any.Type, metadata: UnsafeMutablePointer<Layout>, base: UnsafeMutablePointer<Int>) {
        self.type = type
        self.metadata = metadata
        self.nominalTypeDescriptor = metadata.pointee.typeDescriptor
        self.base = base
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
        var info = TypeInfo(metadata: self)
        info.properties = properties()
        info.mangledName = mangledName()
        info.genericTypes = genericParameters()
        return info
    }
}
