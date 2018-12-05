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

struct ClassMetadata: MetadataType {
    
    var type: Any.Type
    var metadata: UnsafeMutablePointer<ClassMetadataLayout>
    var typeDescriptor: UnsafeMutablePointer<ClassTypeDescriptor>
    var base: UnsafeMutablePointer<Int>
    
    init(type: Any.Type, metadata: UnsafeMutablePointer<Layout>, base: UnsafeMutablePointer<Int>) {
        self.type = type
        self.metadata = metadata
        self.typeDescriptor = metadata.pointee.typeDescriptor
        self.base = base
    }
    
    mutating func className() -> String {
        return String(cString: typeDescriptor.pointee.className.advanced())
    }
    
    mutating func numberOfFields() -> Int {
        return typeDescriptor.pointee
            .numberOfFields
            .getInt()
    }
    
    mutating func fieldOffsets() -> [Int] {
        return typeDescriptor.pointee
            .fieldOffsetVectorOffset
            .vector(metadata: base, n: numberOfFields())
            .map{ Int($0) }
    }
    
    func superClassMetadata() -> ClassMetadata? {
        let superClass = metadata.pointee.superClass
        // type comparison directly to NSObject.self does not work.
        // just compare the type name instead.
        if superClass != swiftObject() && "\(superClass)" != "NSObject" {
            return ClassMetadata(type: superClass)
        } else {
            return nil
        }
    }
    
    mutating func toTypeInfo() -> TypeInfo {
        var info = TypeInfo(metadata: self)
        info.mangledName = className()
        
        info.properties = getProperties(of: type, offsets: fieldOffsets())
        
        var superClass = superClassMetadata()
        while var sc = superClass {
            info.inheritance.append(sc.type)
            let superInfo = sc.toTypeInfo()
            info.properties.append(contentsOf: superInfo.properties)
            superClass = sc.superClassMetadata()
        }
        return info
    }
}
