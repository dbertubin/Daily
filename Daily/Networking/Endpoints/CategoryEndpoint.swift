//
//  CategoryEndpoint.swift
//  Daily
//
//  Created by Derek Bertubin on 8/9/18.
//  Copyright © 2018 Derek Bertubin. All rights reserved.
//

import Foundation
//https://theysaidso.com/api/#

struct CategoryEndpoint: Endpoint {
    var url: URL?
    var headers = HTTPHeaders()
    var method: HTTPMethod = .get
    var baseURL: String = "http://quotes.rest/qod/"
    var path: String = "categories.json"
    init(parameters: CategoryEndpointParameters? = nil) {
        url = URL(string: baseURL + path)
        guard let parameters = parameters else {
            return
        }
        url = url?.appendingQueryParameters(parameters.payload)
    }
    
}

struct CategoryEndpointParameters {
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
