//
//  ProtocolDescriptor.swift
//  Runtime
//
//  Created by Wes Wickwire on 11/4/17.
//  Copyright © 2017 Wes Wickwire. All rights reserved.
//

import Foundation



struct ProtocolDescriptor {
    var isaPointer: Int
    var mangledName: UnsafeMutablePointer<CChar>
    var inheritedProtocolsList: Int
    var requiredInstanceMethods: Int
    var requiredClassMethods: Int
    var optionalInstanceMethods: Int
    var optionalClassMethods: Int
    var instanceProperties: Int
    var protocolDescriptorSize: Int32
    var flags: Int32
}
