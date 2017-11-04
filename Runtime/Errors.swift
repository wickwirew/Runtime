//
//  Errors.swift
//  Runtime
//
//  Created by Wes Wickwire on 11/2/17.
//  Copyright © 2017 Wes Wickwire. All rights reserved.
//

import Foundation


enum RuntimeError: Error {
    case couldNotGetTypeInfo
    case couldNotGetPointer
    case couldNotCastValue
    case noPropertyNamed
    case unableToBuildType
}
