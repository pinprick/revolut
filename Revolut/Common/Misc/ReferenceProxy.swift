//
//  Box.swift
//  Revolut
//
//  Created by Igor Shvetsov on 21/05/2019.
//  Copyright © 2019 Igor Shvetsov. All rights reserved.
//

import Foundation

public final class ReferenceProxy<T> {
    var value: T

    init(value: T) {
        self.value = value
    }
}

extension ReferenceProxy where T == Array<Any> {
    
    convenience init(_ value: T) {
        self.init(value: value)
    }
    
    public subscript(_ index: Int) -> T.Element? {
        return value[index]
    }
    
    public func append(_ newElement: T.Element) {
        value.append(newElement)
    }
    
    public func insert(_ newElement: T.Element, at i: Int) {
        value.insert(newElement, at: i)
    }
    
    public var first: T.Element? {
        return value.first
    }
}
