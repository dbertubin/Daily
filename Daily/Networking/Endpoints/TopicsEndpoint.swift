//
//  TopicsEndpoint.swift
//  Daily
//
//  Created by Derek Bertubin on 8/7/18.
//  Copyright © 2018 Derek Bertubin. All rights reserved.
//

import Foundation
struct TopicsEndpoint: Endpoint {
    var url: URL?
    var headers = HTTPHeaders()
    var method: HTTPMethod = .get
    var baseURL: String = "https://healthruwords.p.mashape.com/v1/"
    var path: String = "topics/"
    
    init() {
        url = URL(string: baseURL + path)
    }
}   
