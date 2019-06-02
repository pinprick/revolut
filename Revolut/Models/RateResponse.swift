//
//  RateResponse.swift
//  Revolut
//
//  Created by Igor Shvetsov on 19/05/2019.
//  Copyright © 2019 Igor Shvetsov. All rights reserved.
//

import Foundation

fileprivate enum Constants {
    static let baseURL: String = "https://revolut.duckdns.org/"
    static let path: String = "latest"
}

fileprivate typealias C = Constants

struct RateResponse: Codable {
    var base: String
    var date: String
    var rates: [String: Double]
}

extension RateResponse: Equatable {}

// MARK: Networking

typealias RateResponseHandler = Result<RateResponse, Error>

extension RateResponse {

    static func resource(params: [String: String]) -> Resource<RateResponse> {
        
        let stringURL = C.baseURL
        let path = C.path
        
        guard let url = URL(string: C.baseURL, path: C.path, params: params) else {
            fatalError("Couldn't create an url with string '\(stringURL)', path: '\(path)' and params: '\(params)'")
        }
        return Resource(get: url)
    }
}
