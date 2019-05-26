//
//  Box.swift
//  Revolut
//
//  Created by Igor Shvetsov on 21/05/2019.
//  Copyright © 2019 Igor Shvetsov. All rights reserved.
//

import Foundation

final class ReferenceProxy<T> {
    var value: T
    
    init(value: T) {
        self.value = value
    }
}

