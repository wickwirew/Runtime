//
//  MetadataType.swift
//  Runtime
//
//  Created by Wes Wickwire on 11/1/17.
//  Copyright © 2017 Wes Wickwire. All rights reserved.
//

import Foundation


protocol MetadataLayoutType {
    var valueWitnessTable: UnsafePointer<ValueWitnessTable> { get set }
}
