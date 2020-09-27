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

protocol Getters {}
extension Getters {
    static func get(from pointer: UnsafeRawPointer) -> Any {
        return pointer.assumingMemoryBound(to: Self.self).pointee
    }
}

func getters(type: Any.Type) -> Getters.Type {
    let container = ProtocolTypeContainer(type: type, witnessTable: 0)
    return unsafeBitCast(container, to: Getters.Type.self)
}

protocol Setters {}
extension Setters {
    static func set(value: Any, pointer: UnsafeMutableRawPointer, initialize: Bool = false) {
        if let value = value as? Self {
            let boundPointer = pointer.assumingMemoryBound(to: self);
            if initialize {
                boundPointer.initialize(to: value)
            } else {
                boundPointer.pointee = value
            }
        }
    }
}

func setters(type: Any.Type) -> Setters.Type {
    let container = ProtocolTypeContainer(type: type, witnessTable: 0)
    return unsafeBitCast(container, to: Setters.Type.self)
}
