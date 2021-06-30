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

// Note: With the release of swift 5.4 the ClassMetadataLayout changed for platforms without Objective-C interoperability
// see:  https://github.com/apple/swift/commit/38fc849a1fc8ea703de2fd1f280b43c682b70257#diff-22fb9f1513d9c05f34d493826b4553bba65a4336a41ae4413678feec549db3a5
// related issue: https://github.com/wickwirew/Runtime/issues/92

// Swift class or objc class
struct AnyClassMetadataLayout {
    var _kind: Int // isaPointer for classes
    var superClass: Any.Type

    // see comment above
    #if !swift(>=5.4) || canImport(Darwin)
    var objCRuntimeReserve: (Int, Int)
    var rodataPointer: Int
    #endif
    
    var isSwiftClass: Bool {
        // see comment above
        #if !swift(>=5.4) || canImport(Darwin)
        return (rodataPointer & classIsSwiftMask()) != 0
        #else
        return true
        #endif
    }
}

struct ClassMetadataLayout: NominalMetadataLayoutType {
    var _kind: Int // isaPointer for classes
    var superClass: Any.Type

    // see comment above
    #if !swift(>=5.4) || canImport(Darwin)
    var objCRuntimeReserve: (Int, Int)
    var rodataPointer: Int
    #endif

    var classFlags: Int32
    var instanceAddressPoint: UInt32
    var instanceSize: UInt32
    var instanceAlignmentMask: UInt16
    var reserved: UInt16
    var classSize: UInt32
    var classAddressPoint: UInt32
    var typeDescriptor: UnsafeMutablePointer<ClassTypeDescriptor>
    var iVarDestroyer: UnsafeRawPointer
}
