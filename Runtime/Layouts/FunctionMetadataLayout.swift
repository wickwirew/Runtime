//
//  FunctionMetadataLayout.swift
//  Runtime
//
//  Created by Wes Wickwire on 11/4/17.
//  Copyright © 2017 Wes Wickwire. All rights reserved.
//

import Foundation



struct FunctionMetadataLayout: MetadataLayoutType {
    var valueWitnessTable: UnsafePointer<ValueWitnessTable>
    var kind: Int
    var flags: Int
    var argumentVector: Vector<Any.Type>
}
