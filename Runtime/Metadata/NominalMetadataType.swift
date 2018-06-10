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
    
    mutating func fieldNames() -> [String] {
        return [String].from(pointer: nominalTypeDescriptor.pointee.fieldNames.advanced(), n: numberOfFields())
    }
    
    mutating func fieldTypeAccessor() -> FieldTypeAccessor {
        let function = nominalTypeDescriptor.pointee.fieldTypeAccessor.advanced()
        return unsafeBitCast(function, to: FieldTypeAccessor.self)
    }
    
    mutating func fieldTypes() -> [Any.Type] {
        let start = fieldTypeAccessor()(base)
        let types = start.vector(n: numberOfFields())
        return types.map{ unsafeBitCast($0, to: Any.Type.self) }
    }
    
    mutating func genericParameterCount() -> Int {
        return nominalTypeDescriptor.pointee.exclusiveGenericParametersCount.getInt()
    }
    
    mutating func genericParameters() -> [Any.Type] {
        return nominalTypeDescriptor.pointee.genericParameterVector.vector(metadata: base, n: genericParameterCount())
    }
    
    mutating func properties() -> [PropertyInfo] {
        let names = fieldNames()
        let offsets = fieldOffsets()
        let types = fieldTypes()
        let num = numberOfFields()
        var properties = [PropertyInfo]()
        for i in 0..<num {
            properties.append(PropertyInfo(name: names[i], type: types[i], offset: offsets[i], ownerType: type))
        }
        return properties
    }
    
    mutating func toTypeInfo() -> TypeInfo {
        var info = TypeInfo(nominalMetadata: self)
        info.properties = properties()
        return info
    }
}
