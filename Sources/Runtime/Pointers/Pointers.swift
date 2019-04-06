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

func withValuePointer<Value, Result>(
    of value: inout Value,
    _ body: (UnsafeMutableRawPointer) throws -> Result) throws -> Result {
    
    let kind = Kind(type: Value.self)
    
    switch kind {
    case .struct:
        return try withUnsafePointer(to: &value) { try body($0.mutable.raw) }
    case .class:
        return try withClassValuePointer(of: &value, body)
    case .existential:
        return try withExistentialValuePointer(of: &value, body)
    default:
        throw RuntimeError.couldNotGetPointer(type: Value.self, value: value)
    }
}

func withClassValuePointer<Value, Result>(
    of value: inout Value,
    _ body: (UnsafeMutableRawPointer) throws -> Result) throws -> Result {
    return try withUnsafePointer(to: &value) {
        let pointer = $0.withMemoryRebound(to: UnsafeMutableRawPointer.self, capacity: 1) {$0.pointee}
        return try body(pointer)
    }
}

func withExistentialValuePointer<Value, Result>(
    of value: inout Value,
    _ body: (UnsafeMutableRawPointer) throws -> Result) throws -> Result {
    return try withUnsafePointer(to: &value) {
        let container = $0.withMemoryRebound(to: ExistentialContainer.self, capacity: 1) {$0.pointee}
        let info = try metadata(of: container.type)
        if info.kind == .class || info.size > ExistentialContainerBuffer.size() {
            let base = $0.withMemoryRebound(to: UnsafeMutableRawPointer.self, capacity: 1) {$0.pointee}
            if info.kind == .struct {
                return try body(base.advanced(by: existentialHeaderSize))
            } else {
                return try body(base)
            }
        } else {
            return try body($0.mutable.raw)
        }
    }
}

var existentialHeaderSize: Int {
    if is64Bit {
        return 16
    } else {
        return 8
    }
}

var is64Bit: Bool {
    return MemoryLayout<Int>.size == 8
}
