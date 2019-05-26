//
//  RateService.swift
//  Revolut
//
//  Created by Igor Shvetsov on 10/05/2019.
//  Copyright © 2019 Igor Shvetsov. All rights reserved.
//

import Foundation

typealias RatesHandler = Result<[String: Double], Error>

final class RateService {
    
    func getCurrency(base: String, completion: @escaping (RatesHandler) -> Void) {
        let params = ["base": base]

        URLSession.shared.load(RateResponse.resource(params: params)) { result in
            switch result {
            case .success(let rateResponse):
                completion(RatesHandler.success(rateResponse?.rates ?? [:]))
            
            case .failure(let error):
                completion(RatesHandler.failure(error))
            }
        }
    }
}
