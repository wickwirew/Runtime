//
//  TupleMetadataLayout.swift
//  Runtime
//
//  Created by Wes Wickwire on 11/4/17.
//  Copyright © 2017 Wes Wickwire. All rights reserved.
//

import Foundation



struct TupleMetadataLayout: MetadataLayoutType {
    var valueWitnessTable: UnsafePointer<ValueWitnessTable>
    var kind: Int
    var numberOfElements: Int
    var labelsString: UnsafeMutablePointer<CChar>
    var elementVector: Vector<TupleElementLayout>
}


struct TupleElementLayout {
    var type: Any.Type
    var offset: Int
}

struct Vector<Element> {
    var element: Element
    mutating func vector(n: IntegerConvertible) -> [Element] {
        return withUnsafePointer(to: &self) {
            $0.withMemoryRebound(to: Element.self, capacity: 1) { start in
                return start.vector(n: n)
            }
        }
    }
}
