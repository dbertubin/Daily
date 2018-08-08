//
//  ForismaticEndpoint.swift
//  Daily
//
//  Created by Derek Bertubin on 8/7/18.
//  Copyright © 2018 Derek Bertubin. All rights reserved.
//

import Foundation
struct ForismaticEndpoint: Endpoint {
    var url: URL?
    var headers = HTTPHeaders()
    var method: HTTPMethod = .post
    var baseURL: String = "http://api.forismatic.com/api/"
    var path: String = "1.0//"
    var parameters = [
        "method":"getQuote",
        "format":"json",
        "lang":"en"
    ]
    init() {
        let url = URL(string: baseURL + path)
        self.url = url?.appendingQueryParameters(parameters)
    }
    
}
