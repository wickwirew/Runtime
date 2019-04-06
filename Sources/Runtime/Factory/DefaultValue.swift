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

public protocol DefaultConstructor {
    init()
}

extension Int: DefaultConstructor {}
extension Int8: DefaultConstructor {}
extension Int16: DefaultConstructor {}
extension Int32: DefaultConstructor {}
extension Int64: DefaultConstructor {}
extension UInt: DefaultConstructor {}
extension UInt8: DefaultConstructor {}
extension UInt16: DefaultConstructor {}
extension UInt32: DefaultConstructor {}
extension UInt64: DefaultConstructor {}
extension String: DefaultConstructor {}

extension Bool: DefaultConstructor {}
extension Double: DefaultConstructor {}
extension Decimal: DefaultConstructor {}
extension Float: DefaultConstructor {}
extension Date: DefaultConstructor {}
extension UUID: DefaultConstructor {}

extension Array: DefaultConstructor {}
extension Dictionary: DefaultConstructor {}
extension Set: DefaultConstructor {}

extension Character: DefaultConstructor {
    public init() {
        self = " "
    }
}
