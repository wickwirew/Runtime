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


typealias FieldTypeAccessor = @convention(c) (UnsafePointer<Int>) -> UnsafePointer<Int>

struct StructTypeDescriptor {
    var unknown1: Int32
    var unknown2: Int32
    var mangledName: RelativePointer<Int32, CChar>
    var unknown3: Int32
    var numberOfFields: Int32
    var offsetToTheFieldOffsetVector: RelativeVectorPointer<Int32, Int32>
    var fieldTypeAccessor: RelativePointer<Int32, Int>
    var metadataPattern: Int32
    var inclusiveGenericParametersCount: Int32
    var exclusiveGenericParametersCount: Int32
    var idk2: Int32
    var genericParameterVector: RelativeVectorPointer<Int32, Any.Type>
}

struct ClassTypeDescriptor {
    var unknown1: Int32
    var unknown2: Int32
    var className: RelativePointer<Int32, CChar>
    var superClass: RelativePointer<Int32, Int>
    var metadataNegativeSizeInWords: Int32
    var resilientMetadataBounds: Int32
    var metadataPositiveSizeInWords: Int32
    var numImmediateMembers: Int32
    var numberOfFields: Int32
    var fieldOffsetVectorOffset: RelativeVectorPointer<Int32, Int>
    var unknown11: Int32
    var unknown12: Int32
    var unknown13: Int32
    var unknown14: Int32
    var unknown15: Int32
    var unknown16: Int32
    var unknown17: Int32
    var unknown18: Int32
    var unknown19: Int32
    var unknown20: Int32
}


/*
 
 struct NominalTypeDescriptor {
     var mangledName: RelativePointer<Int32, CChar>
     var numberOfFields: Int32
     var offsetToTheFieldOffsetVector: RelativeVectorPointer<Int32, Int>
     var fieldNames: RelativePointer<Int32, CChar>
     var fieldTypeAccessor: RelativePointer<Int32, Int>
     var metadataPattern: Int32
     var somethingNotInTheDocs: Int32
     var genericParameterVector: RelativeVectorPointer<Int32, Any.Type>
     var inclusiveGenericParametersCount: Int32
     var exclusiveGenericParametersCount: Int32
 }
 
 */
