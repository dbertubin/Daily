//
//  Quote.swift
//  Daily
//
//  Created by Derek Bertubin on 8/7/18.
//  Copyright © 2018 Derek Bertubin. All rights reserved.
//

import Foundation

struct Quote: Decodable {
    
    var identifier: String
    var title: String
    var author: String
    var url: String
    var media: String
    var categoryName: String
    
    enum CodingKeys : String, CodingKey {
        case title
        case author
        case url
        case media
        case categoryName = "cat"
        case identifier = "id"
    }
}
