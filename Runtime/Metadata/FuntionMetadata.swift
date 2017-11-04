//
//  FuntionMetadata.swift
//  Runtime
//
//  Created by Wes Wickwire on 11/4/17.
//  Copyright © 2017 Wes Wickwire. All rights reserved.
//

import Foundation



struct FunctionMetadata: MetadataType {
    
    var type: Any.Type
    var metadata: UnsafeMutablePointer<FunctionMetadataLayout>
    var base: UnsafeMutablePointer<Int>
    
    init(type: Any.Type) {
        self.type = type
        base = metadataPointer(type: type)
        metadata = base.advanced(by: -1).raw.assumingMemoryBound(to: FunctionMetadataLayout.self)
    }
    
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
