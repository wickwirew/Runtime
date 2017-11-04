//
//  ProtocolMetadataLayout.swift
//  Runtime
//
//  Created by Wes Wickwire on 11/4/17.
//  Copyright © 2017 Wes Wickwire. All rights reserved.
//

import Foundation



struct ProtocolMetadataLayout: MetadataLayoutType {
    var valueWitnessTable: UnsafePointer<ValueWitnessTable>
    var kind: Int
    var layoutFlags: Int
    var numberOfProtocols: Int
    var protocolDescriptorVector: UnsafeMutablePointer<ProtocolDescriptor>
}
