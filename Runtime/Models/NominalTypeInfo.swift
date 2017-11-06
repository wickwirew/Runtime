//
//  NominalTypeInfo.swift
//  Runtime
//
//  Created by Wes Wickwire on 11/5/17.
//  Copyright © 2017 Wes Wickwire. All rights reserved.
//

import Foundation

protocol NominalTypeInfo {
    var kind: Kind { get set }
    var name: String { get set }
    var type: Any.Type { get set }
    var mangledName: String { get set }
    var genericTypes: [Any.Type] { get set }
    var numberOfGenericTypes: Int { get set }
    var size: Int { get set }
    var alignment: Int { get set }
    var stride: Int { get set }
}


extension NominalMetadataType {
    mutating func setNominalInfo<Info: NominalTypeInfo>(on info: inout Info) {
        info.kind = kind
        info.name = "\(type)"
        info.type = type
        info.mangledName = mangledName()
        info.genericTypes = genericParameters()
        info.numberOfGenericTypes = genericParameterCount()
        info.size = size
        info.alignment = alignment
        info.stride = stride
    }
}
