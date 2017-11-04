//
//  ClassMetadata.swift
//  Runtime
//
//  Created by Wes Wickwire on 11/1/17.
//  Copyright © 2017 Wes Wickwire. All rights reserved.
//

import Foundation


struct ClassMetadataLayout: NominalMetadataLayoutType {
    var valueWitnessTable: UnsafePointer<ValueWitnessTable>
    var isaPointer: Int
    var superPointer: Int
    var objCRuntimeReserve1: Int
    var objCRuntimeReserve2: Int
    var rodataPointer: Int
    var classFlags: Int32
    var instanceAddressPoint: Int32
    var instanceSize: Int32
    var instanceAlignmentMask: Int16
    var runtimeReserveField: Int16
    var classObjectSize: Int32
    var classObjectAddressPoint: Int32
    var nominalTypeDescriptor: RelativePointer<Int, NominalTypeDescriptor>
}

