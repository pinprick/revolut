//
//  Network.swift
//  Revolut
//
//  Created by Igor Shvetsov on 04/05/2019.
//  Copyright © 2019 Igor Shvetsov. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case apiError(Error)
    case parseError
    case emptyData
}

extension NetworkError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .apiError(let error):
            return error.localizedDescription
        case .parseError:
            return "Couldn't parse"
        case .emptyData:
            return "Empty data"
        }
    }
}

// MARK: HTTP methods

enum HttpMethod<Body> {
    case get
    case post(Body)
}

extension HttpMethod {
    var method: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        }
    }
}

// MARK: Networking API

struct Resource<A> {
    var urlRequest: URLRequest
    let parse: (Data) -> A?
}

extension Resource {
    func map<B>(_ transform: @escaping (A) -> B) -> Resource<B> {
        return Resource<B>(urlRequest: urlRequest) { self.parse($0).map(transform) }
    }
}

extension Resource where A: Decodable {
    init(get url: URL) {
        self.urlRequest = URLRequest(url: url)
        self.parse = { data in
            try? JSONDecoder().decode(A.self, from: data)
        }
    }
    
    init<Body: Encodable>(url: URL, method: HttpMethod<Body>) {
        urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.method
        switch method {
        case .get: ()
        case .post(let body):
            self.urlRequest.httpBody = try! JSONEncoder().encode(body)
        }
        self.parse = { data in
            try? JSONDecoder().decode(A.self, from: data)
        }
    }
}

// MARK: Foundation extensions

extension URLSession {
    func load<A>(_ resource: Resource<A>, completion: @escaping (Result<A?, Error>) -> ()) {
        dataTask(with: resource.urlRequest) { data, _, error in
            if let error = error { completion(.failure(error)) }
            guard let data = data else { completion(.failure(NetworkError.emptyData)); return }
            completion(Result(resource.parse(data), or: NetworkError.parseError))
        }.resume()
    }
}

extension URL {
    init?(string: String, path: String?, params: [String: String]?) {
        self.init(string: string)
        
        if let path = path {
            self.appendPathComponent(path)
        }
        
        if let params = params {
            var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true)!
            
            let queryItems = params.keys.map { key in
                URLQueryItem(name: key, value: params[key])
            }
            urlComponents.queryItems = queryItems
            if let urlWithComponents = urlComponents.url {
                self = urlWithComponents
            }
        }
    }
}
