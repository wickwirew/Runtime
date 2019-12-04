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

struct ClassMetadata: NominalMetadataType {
    
    var pointer: UnsafeMutablePointer<ClassMetadataLayout>
    
    var hasResilientSuperclass: Bool {
        let typeDescriptor = pointer.pointee.typeDescriptor
        return ((typeDescriptor.pointee.flags >> 16) & 0x2000) != 0
    }
    
    var areImmediateMembersNegative: Bool {
        let typeDescriptor = pointer.pointee.typeDescriptor
        return ((typeDescriptor.pointee.flags >> 16) & 0x1000) != 0
    }
    
    var genericArgumentOffset: Int {
        let typeDescriptor = pointer.pointee.typeDescriptor
        
        if !hasResilientSuperclass {
            return areImmediateMembersNegative
                ? -Int(typeDescriptor.pointee.negativeSizeAndBoundsUnion.metadataNegativeSizeInWords)
                : Int(typeDescriptor.pointee.metadataPositiveSizeInWords - typeDescriptor.pointee.numImmediateMembers)
        }
        
        /*
        let storedBounds = typeDescriptor.pointee
            .negativeSizeAndBoundsUnion
            .resilientMetadataBounds()
            .pointee
            .advanced()
            .pointee
        */
        
        // To do this something like `computeMetadataBoundsFromSuperclass` in Metadata.cpp
        // will need to be implemented. To do that we also need to get the resilient superclass
        // from the trailing objects.
        fatalError("Cannot get the `genericArgumentOffset` for classes with a resilient superclass")
    }
    
    func superClassMetadata() -> ClassMetadata? {
        let superClass = pointer.pointee.superClass
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
        info.mangledName = mangledName()
        info.properties = properties()
        info.genericTypes = Array(genericArguments())
        
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
