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
import cruntime

/// Type to use as the context in the `_getFieldAt` function.
struct PropertyInfoContext {
    let name: String
    let type: Any.Type
}

/// Gets the list of properties of the inputted type.
func getProperties(of type: Any.Type, offsets: [Int]) -> [PropertyInfo] {
    return (0..<offsets.count).map{ index in
        let offset = offsets[index]
        var context = PropertyInfoContext(name: "", type: Any.self)
        let pointer = unsafeBitCast(type, to: UnsafeRawPointer.self)
        swift_getFieldAt(pointer, UInt32(index), { name, type, ctx in
            guard let name = name, let ctx = ctx else { 
                return
            }
            let infoContext = ctx.assumingMemoryBound(to: PropertyInfoContext.self)
            infoContext.pointee = PropertyInfoContext(
                name: String(cString: name),
                type: unsafeBitCast(type, to: Any.Type.self)
            )
        }, &context)
        return PropertyInfo(name: context.name, type: context.type, offset: offset, ownerType: type)
    }
}
