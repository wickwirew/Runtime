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


struct StructMetadata: MetadataType {
    
    var type: Any.Type
    var metadata: UnsafeMutablePointer<StructMetadataLayout>
    var typeDescriptor: UnsafeMutablePointer<StructTypeDescriptor>
    var base: UnsafeMutablePointer<Int>
    
    init(type: Any.Type, metadata: UnsafeMutablePointer<StructMetadataLayout>, base: UnsafeMutablePointer<Int>) {
        self.type = type
        self.metadata = metadata
        self.typeDescriptor = metadata.pointee.typeDescriptor
        self.base = base
    }
    
    mutating func mangledName() -> String {
        return String(cString: typeDescriptor.pointee.mangledName.advanced())
    }
    
    mutating func numberOfFields() -> Int {
        return typeDescriptor.pointee.numberOfFields.getInt()
    }
    
    mutating func fieldOffsets() -> [Int] {
        return typeDescriptor.pointee
            .offsetToTheFieldOffsetVector
            .vector(metadata: base, n: numberOfFields())
            .map{ Int($0) }
    }
    
    mutating func properties() -> [PropertyInfo] {
        let offsets = fieldOffsets()
        let fieldDescriptor = typeDescriptor.pointee
            .fieldDescriptor
            .advanced()
        
        
        
        return (0..<numberOfFields()).map { i in
            let record = fieldDescriptor
                .pointee
                .fields
                .element(at: i)
            
            return PropertyInfo(
                name: record.pointee.fieldName(),
                type: record.pointee.type(
                    genericContext: typeDescriptor,
                    genericArguments: metadata.pointee.genericArgumentVector.element(at: 0)
                ),
                offset: offsets[i],
                ownerType: type
            )
        }
    }
    
    mutating func genericArguments() -> [Any.Type] {
        let n = metadata.pointee.typeDescriptor.pointee.numberOfGenericArguments
        return metadata.pointee
            .genericArgumentVector
            .vector(n: n)
    }
    
    mutating func toTypeInfo() -> TypeInfo {
        var info = TypeInfo(metadata: self)
        info.properties = properties()
        info.mangledName = mangledName()
        return info
    }
}
