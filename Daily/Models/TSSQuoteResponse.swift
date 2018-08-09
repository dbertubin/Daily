//
//  TSSQuoteResponse.swift
//  Daily
//
//  Created by Derek Bertubin on 8/8/18.
//  Copyright © 2018 Derek Bertubin. All rights reserved.
//

import Foundation

struct TSSQuoteResponse: Codable {
    var contents: [String: TSSQuote]
    
    enum CodingKeys : String, CodingKey {
        case contents
    }
}
