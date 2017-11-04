//
//  FunctionInfo.swift
//  Runtime
//
//  Created by Wes Wickwire on 11/4/17.
//  Copyright © 2017 Wes Wickwire. All rights reserved.
//

import Foundation


struct FunctionInfo {
    var numberOfArguments: Int
    var argumentTypes: [Any.Type]
    var returnType: Any.Type
    var `throws`: Bool
}
