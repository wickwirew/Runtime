//
//  StructMetadata.swift
//  Runtime
//
//  Created by Wes Wickwire on 11/1/17.
//  Copyright © 2017 Wes Wickwire. All rights reserved.
//

import Foundation


struct StructMetadataLayout: NominalMetadataLayoutType {
    var valueWitnessTable: UnsafePointer<ValueWitnessTable>
    var kind: Int
    var nominalTypeDescriptor: RelativePointer<Int, NominalTypeDescriptor>
    var fieldVectorOffset: RelativeVectorPointer<Int, Int>
}
