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


func metadataPointer(type: Any.Type) -> UnsafeMutablePointer<Int> {
    return unsafeBitCast(type, to: UnsafeMutablePointer<Int>.self)
}

func metadata(of type: Any.Type) throws -> MetadataInfo {

    let kind = Kind(type: type)

    switch kind {
    case .struct:
        return StructMetadata(type: type)
    case .class:
        return ClassMetadata(type: type)
    case .protocol:
        return ProtocolMetadata(type: type)
    case .tuple:
        return TupleMetadata(type: type)
    case .enum:
        return EnumMetadata(type: type)
    default:
        throw RuntimeError.couldNotGetTypeInfo(type: type, kind: kind)
    }
}

func swiftObject() -> Any.Type {
    class Temp {}
    let md = ClassMetadata(type: Temp.self)
    return md.metadata.pointee.superClass
}

