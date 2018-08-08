//
//  ForismaticQuote.swift
//  Daily
//
//  Created by Derek Bertubin on 8/7/18.
//  Copyright © 2018 Derek Bertubin. All rights reserved.
//

import Foundation

struct ForismaticQuote: Decodable {
    
    var quoteText: String
    var quoteAuthor: String
    
    enum CodingKeys : String, CodingKey {
        case quoteText
        case quoteAuthor
    }
}
