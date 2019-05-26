//
//  Dependencies.swift
//  Revolut
//
//  Created by Igor Shvetsov on 19/05/2019.
//  Copyright © 2019 Igor Shvetsov. All rights reserved.
//

import Foundation

struct AppDependencies {
    let rateService: RateService
}

extension AppDependencies: HasRateService {}
