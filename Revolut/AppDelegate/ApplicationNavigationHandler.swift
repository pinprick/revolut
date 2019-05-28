//
//  ApplicationNavigationHandler.swift
//  Revolut
//
//  Created by Igor Shvetsov on 19/05/2019.
//  Copyright © 2019 Igor Shvetsov. All rights reserved.
//

import Foundation
import UIKit

class ApplicationNavigationHandler: AppDelegateHandlerType {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        
        // TODO: implement proper navigation with Dependecy injection
        
        let dependencies = AppDependencies(rateService: NetworkRateService())
        
        let rootVC = ConverterVC.instantiate()
        let presenter = CommonConverterPresenter(view: rootVC, dependencies: dependencies)
        rootVC.configure(presenter: presenter)
        
        let window = application.keyWindow
        window?.rootViewController = rootVC
        
        return true
    }
}
