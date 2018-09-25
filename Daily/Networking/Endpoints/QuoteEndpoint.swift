//
//  TTSEndpoint.swift
//  Daily
//
//  Created by Derek Bertubin on 8/8/18.
//  Copyright © 2018 Derek Bertubin. All rights reserved.
//

import Foundation

//https://theysaidso.com/api/#

struct QuoteEndpoint: Endpoint {
    var url: URL?
    var headers = HTTPHeaders()
    var method: HTTPMethod = .post
    var baseURL: String = "http://quotes.rest/quote/"
    var path: String = "search.json"
    var parameters: QuoteEndpointParameters?
    init(parameters: QuoteEndpointParameters? = nil) {
        let url = URL(string: baseURL + path)
        
        guard let parameters = parameters else {
            return
        }
        self.url = url?.appendingQueryParameters(parameters.payload)
    }
    
}

struct QuoteEndpointParameters {
    var category: String?
    var payload: [String: String] {
        var payload = [String: String]()
        if let category = category {
              payload["category"] = "\(category)"
        }
        return payload
    }

    init(category: String? = nil) {
        self.category = category
    }
}
