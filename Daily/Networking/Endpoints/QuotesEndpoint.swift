//
//  QuotesEndpoint.swift
//  Daily
//
//  Created by Derek Bertubin on 8/7/18.
//  Copyright © 2018 Derek Bertubin. All rights reserved.
//

import Foundation

struct QuotesEndpoint: Endpoint {
    var url: URL?
    var headers = HTTPHeaders()
    var method: HTTPMethod = .get
    var baseURL: String = "https://healthruwords.p.mashape.com/v1/"
    var path: String = "quotes/"
    var parameters: QuotesEndpointParameters
    
    init(parameters: QuotesEndpointParameters) {
        self.parameters = parameters
        
        let url = URL(string: baseURL + path)
        self.url = url?.appendingQueryParameters(parameters.payload)
    }
}

struct QuotesEndpointParameters {
    enum ImageSize: String {
        case small
        case medium
        case large
    }
    var maximumResultCount: Int
    var imageSize: ImageSize
    var topic: String
    
    var payload: [String: String] {
        var payload = [String: String]()
        payload["maxR"] = "\(maximumResultCount)"
        payload["size"] = imageSize.rawValue
        payload["t"] = topic
        return payload
    }
    
    init(maximumResultCount: Int, imageSize: ImageSize, topic: String?) {
        self.maximumResultCount = maximumResultCount
        self.imageSize = imageSize
        self.topic = topic ?? ""
    }
}
