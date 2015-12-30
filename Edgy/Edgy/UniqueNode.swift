//
//  UniqueNode.swift
//  Edgy
//
//  Created by Jaden Geller on 12/29/15.
//  Copyright © 2015 Jaden Geller. All rights reserved.
//

public class UniqueNode<Element>: Hashable {
    public let element: Element
    
    public init(_ element: Element) {
        self.element = element
    }

    public var hashValue: Int {
        return ObjectIdentifier(self).hashValue
    }
}

public func ==<Element>(lhs: UniqueNode<Element>, rhs: UniqueNode<Element>) -> Bool {
    return lhs === rhs
}