//
//  EnumMetadataLayout.swift
//  Runtime
//
//  Created by Wes Wickwire on 11/5/17.
//  Copyright © 2017 Wes Wickwire. All rights reserved.
//

import Foundation



struct EnumMetadataLayout: NominalMetadataLayoutType {
    var valueWitnessTable: UnsafePointer<ValueWitnessTable>
    var kind: Int
    var nominalTypeDescriptor: RelativePointer<Int, NominalTypeDescriptor>
    var parent: Any.Type
//    var genericParameters: Vector<Any.Type>
}
