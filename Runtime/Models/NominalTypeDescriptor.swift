//
//  MetadataModels.swift
//  Runtime
//
//  Created by Wes Wickwire on 11/1/17.
//  Copyright © 2017 Wes Wickwire. All rights reserved.
//

import Foundation


typealias FieldTypeAccessor = @convention(c) (UnsafePointer<Int>) -> UnsafePointer<Int>

struct NominalTypeDescriptor {
    var mangledName: RelativePointer<Int32, CChar>
    var numberOfFields: Int32
    var offsetToTheFieldOffsetVector: MetadataRelativeVectorPointer<Int32, Int>
    var fieldNames: RelativePointer<Int32, CChar>
    var fieldTypeAccessor: RelativePointer<Int32, Int>
    var metadataPattern: Int32
    var somethingNotInTheDocs: Int32
    var genericParameterVector: MetadataRelativeVectorPointer<Int32, Any.Type>
    var inclusiveGenericParametersCount: Int32
    var exclusiveGenericParametersCount: Int32
}
