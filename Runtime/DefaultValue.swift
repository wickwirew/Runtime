//
//  DefaultValue.swift
//  Runtime
//
//  Created by Wes Wickwire on 11/3/17.
//  Copyright © 2017 Wes Wickwire. All rights reserved.
//

import Foundation
import UIKit


public protocol DefaultConstructor {
    init()
}

extension Int: DefaultConstructor {}
extension Int8: DefaultConstructor {}
extension Int16: DefaultConstructor {}
extension Int32: DefaultConstructor {}
extension Int64: DefaultConstructor {}
extension UInt: DefaultConstructor {}
extension UInt8: DefaultConstructor {}
extension UInt16: DefaultConstructor {}
extension UInt32: DefaultConstructor {}
extension UInt64: DefaultConstructor {}
extension String: DefaultConstructor {}
extension Bool: DefaultConstructor {}
extension Double: DefaultConstructor {}
extension Decimal: DefaultConstructor {}
extension Date: DefaultConstructor {}
extension Array: DefaultConstructor {}
extension Dictionary: DefaultConstructor {}
extension CGFloat: DefaultConstructor {}
extension CGRect: DefaultConstructor {}
extension CGPoint: DefaultConstructor {}
extension CGSize: DefaultConstructor {}
extension NSObject: DefaultConstructor {}


