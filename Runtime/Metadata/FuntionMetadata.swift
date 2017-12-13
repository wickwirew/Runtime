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

struct FunctionMetadata: MetadataType {

    var type: Any.Type
    var metadata: UnsafeMutablePointer<FunctionMetadataLayout>
    var base: UnsafeMutablePointer<Int>

    func info() -> FunctionInfo {
        let (numberOfArguments, argumentTypes, returnType) = argumentInfo()
        return FunctionInfo(numberOfArguments: numberOfArguments,
                            argumentTypes: argumentTypes,
                            returnType: returnType,
                            throws: `throws`())
    }

    private func argumentInfo() -> (Int, [Any.Type], Any.Type) {
        let n = numberArguments()
        var a = metadata.pointee.argumentVector.vector(n: n + 1)
        let resultType = a[0]
        let argsType = a[1]

        if Kind(type: argsType) == .tuple {
            let md = TupleMetadata(type: argsType)
            let elements = md.elements()
            return (elements.count, elements.map{$0.type}, resultType)
        } else {
            return (n, [argsType], resultType)
        }
    }

    private func numberArguments() -> Int {
        return metadata.pointee.flags & 0x00FFFFFF
    }

    private func `throws`() -> Bool {
        return metadata.pointee.flags & 0x10000000 != 0
    }
}
