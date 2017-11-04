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



struct TupleMetadata: MetadataType, TypeInfoConvertible {
    
    var type: Any.Type
    var metadata: UnsafeMutablePointer<TupleMetadataLayout>
    var base: UnsafeMutablePointer<Int>
    
    init(type: Any.Type) {
        self.type = type
        base = metadataPointer(type: type)
        metadata = base.advanced(by: -1).raw.assumingMemoryBound(to: TupleMetadataLayout.self)
    }
    
    func numberOfElements() -> Int {
        return metadata.pointee.numberOfElements
    }
    
    func labels() -> [String] {
        guard metadata.pointee.labelsString.hashValue != 0 else { return (0..<numberOfElements()).map{ a in "" } }
        var labels = String(cString: metadata.pointee.labelsString).components(separatedBy: " ")
        labels.removeLast()
        return labels
    }
    
    func elements() -> [TupleElementLayout] {
        let n = numberOfElements()
        guard n > 0 else { return [] }
        return metadata.pointee.elementVector.vector(n: n)
    }
    
    mutating func toTypeInfo() -> TypeInfo {
        let names = labels()
        let el = elements()
        let num = numberOfElements()
        var properties = [PropertyInfo]()
        for i in 0..<num {
            properties.append(PropertyInfo(name: names[i], type: el[i].type, offset: el[i].offset, ownerType: type))
        }
        return TypeInfo(
            kind: kind,
            name: "\(type)",
            type: type,
            mangledName: "",
            properties: properties,
            genericTypes: [],
            numberOfProperties: num,
            numberOfGenericTypes: 0,
            size: size,
            alignment: alignment,
            stride: stride
        )
    }
}
