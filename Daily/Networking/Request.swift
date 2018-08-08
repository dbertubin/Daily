//
//  Request.swift
//  Daily
//
//  Created by Derek Bertubin on 8/7/18.
//  Copyright © 2018 Derek Bertubin. All rights reserved.
//

import Foundation
struct Request {
    var endpoint: Endpoint
    init(for endpoint: Endpoint) {
        self.endpoint = endpoint
        
    }
    func urlRequest() -> URLRequest? {
        guard let url = endpoint.url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers.payload
        return request
    }
}
