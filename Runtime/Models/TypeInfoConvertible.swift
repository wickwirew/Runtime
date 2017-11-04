//
//  TypeInfoConvertible.swift
//  Runtime
//
//  Created by Wes Wickwire on 11/2/17.
//  Copyright © 2017 Wes Wickwire. All rights reserved.
//

import Foundation



protocol TypeInfoConvertible {
    mutating func toTypeInfo() -> TypeInfo
}
