//
//  TSSQuote.swift
//  Daily
//
//  Created by Derek Bertubin on 8/8/18.
//  Copyright © 2018 Derek Bertubin. All rights reserved.
//

import Foundation

struct Quote: Codable {
    
    var quote: String
    var author: String
    
    enum CodingKeys : String, CodingKey {
        case quote
        case author
    }
}
