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

public struct TypeInfo {

    public var kind: Kind = .unknown
    public var name: String = ""
    public var type: Any.Type = Any.self
    public var mangledName: String = ""
    public var properties: [PropertyInfo] = []
    public var inheritance: [Any.Type] = []
    public var genericTypes: [Any.Type] = []
    public var size: Int = 0
    public var alignment: Int = 0
    public var stride: Int = 0

    init<Metadata: MetadataType>(metadata: Metadata) {
        kind = metadata.kind
        name = String(describing: metadata.type)
        type = metadata.type
        size = metadata.size
        alignment = metadata.alignment
        stride = metadata.stride
    }

    init<Metadata: NominalMetadataType>(nominalMetadata: Metadata) {
        self.init(metadata: nominalMetadata)
        var nominalMetadata = nominalMetadata
        mangledName = nominalMetadata.mangledName()
        genericTypes = nominalMetadata.genericParameters()
    }

    public var superClass: Any.Type? {
        return inheritance.first
    }

    public func property(named: String) throws -> PropertyInfo {
        if let prop = properties.first(where: { $0.name == named }) {
            return prop
        }

        throw RuntimeError.noPropertyNamed(name: named)
    }
}

public func typeInfo(of type: Any.Type) throws -> TypeInfo {
    let kind = Kind(type: type)

    var typeInfoConvertible: TypeInfoConvertible

    switch kind {
    case .struct:
        typeInfoConvertible = StructMetadata(type: type)
    case .class:
        typeInfoConvertible = ClassMetadata(type: type)
    case .protocol:
        typeInfoConvertible = ProtocolMetadata(type: type)
    case .tuple:
        typeInfoConvertible = TupleMetadata(type: type)
    case .enum:
        typeInfoConvertible = EnumMetadata(type: type)
    default:
        throw RuntimeError.couldNotGetTypeInfo(type: type, kind: kind)
    }

    return typeInfoConvertible.toTypeInfo()
}
