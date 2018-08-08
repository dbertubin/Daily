//
//  Dictionary+URLQueryParameterStringConvertible.swift
//  Daily
//
//  Created by Derek Bertubin on 8/7/18.
//  Copyright © 2018 Derek Bertubin. All rights reserved.
//

import Foundation
extension Dictionary: URLQueryParameterStringConvertible {
    var queryParameters: String {
        var parts: [String] = []
        for (key, value) in self {
            let part = String(format: "%@=%@",
                              String(describing: key).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                              String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            parts.append(part as String)
        }
        return parts.joined(separator: "&")
    }
}
