//
//  AppDelegateHandlerType.swift
//  Revolut
//
//  Created by Igor Shvetsov on 19/05/2019.
//  Copyright © 2019 Igor Shvetsov. All rights reserved.
//

import Foundation
import UIKit

protocol AppDelegateHandlerType {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
}
