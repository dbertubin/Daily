//
//  Endpoint.swift
//  Daily
//
//  Created by Derek Bertubin on 8/7/18.
//  Copyright © 2018 Derek Bertubin. All rights reserved.
//

import Foundation
protocol Endpoint {
    var baseURL: String { get set } // https://example.com
    var path: String { get set} // /users/
    var method: HTTPMethod { get set } // .get
    var url: URL? {get set}
    var headers: HTTPHeaders { get set }
}
