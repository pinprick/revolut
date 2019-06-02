//
//  Mocks.swift
//  RevolutTests
//
//  Created by Igor Shvetsov on 28/05/2019.
//  Copyright © 2019 Igor Shvetsov. All rights reserved.
//

import Foundation
import UIKit

class ConverterViewMock: UIView, ConverterView, ErrorHandable {
    
    var models: RArray<Currency>!
    var error: Error?
    
    func setup(with models: RArray<Currency>) {
        self.models = models
    }
    
    func update() {
        //
    }
    
    func reload() {
        //
    }
    
    func showLoader(_ visible: Bool) {
        //
    }
    
    func display(error: Error) {
        self.error = error
    }
    
}

class RateServiceMock: RateService {
    
    var rates: [String: Double]
    
    init(rates: [String: Double]) {
        self.rates = rates
    }
    
    func getCurrency(base: String, completion: @escaping (RatesHandler) -> Void) {
        let handler = RatesHandler.success(rates)
        completion(handler)
    }
}

enum ErrorMock: Error {
    case loadRatesError
    case notInitialized
}

extension ErrorMock: LocalizedError {

    var localizedDescription: String {
        switch self {
        case .loadRatesError:
            return "LOAD RATES ERROR"
        case .notInitialized:
            return "Result isn't initialised"
        }
    }
}

class FailureRateServiceMock: RateService {
    
    func getCurrency(base: String, completion: @escaping (RatesHandler) -> Void) {
        let handler = RatesHandler.failure(ErrorMock.loadRatesError)
        completion(handler)
    }
}

struct ResponseAndError {
    let response: Any?
    let error: Error?
    
    init<A>(response: A?, error: Error? = nil) {
        self.response = response.map { $0 }
        self.error = error
    }
}

struct SessionMock<A>: Session  {
    
    let mockData: ResponseAndError
    
    func load<A>(_ resource: Resource<A>, completion: @escaping (Result<A?, Error>) -> ()) {
        guard let response = mockData.response as! A? else {
            fatalError("Wrong type")
        }
        
        if let error = mockData.error {
            completion(Result.failure(error))
        } else {
            completion(Result.success(response))
        }
    }
}
