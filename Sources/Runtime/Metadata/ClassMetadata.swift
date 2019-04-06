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
    
    var pointer: UnsafeMutablePointer<ClassMetadataLayout>
    
    var hasResilientSuperclass: Bool {
        return (0x4000 & pointer.pointee.classFlags) != 0
    }
    
    var areImmediateMembersNegative: Bool {
        return (0x800 & pointer.pointee.classFlags) != 0
    }
    
    var genericArgumentOffset: Int {
        if !hasResilientSuperclass {
//            return areImmediateMembersNegative
//                ? -Int32(pointer.pointee.typeDescriptor.pointee.metadataPositiveSizeInWords)
//                : -Int32(pointer.pointee.typeDescriptor.pointee.metadataPositiveSizeInWords)
            /*
             return areImmediateMembersNegative()
             ? -int32_t(MetadataNegativeSizeInWords)
             : int32_t(MetadataPositiveSizeInWords - NumImmediateMembers);
             */
            
        }
        
        return 10
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
