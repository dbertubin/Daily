//
//  Topic.swift
//  Daily
//
//  Created by Derek Bertubin on 8/7/18.
//  Copyright © 2018 Derek Bertubin. All rights reserved.
//

import Foundation
struct Topic: Decodable {
    var title: String
    enum CodingKeys : String, CodingKey {
        case title = "topic"
    }
    
    static var topicTitles: [String] {
        let titles = [
         "Abundance",
         "Attitude",
         "Beliefs",
         "Believe",
         "Books",
         "Change",
         "Compassion",
         "Courage",
         "Forgiveness",
         "Friendship",
         "Gratitude",
         "Happiness",
         "Healing",
         "Hope",
         "Kindness",
         "Law of Attraction",
         "Leadership",
         "Life",
         "Love",
         "Mindfulness",
         "Motivational",
         "Peace",
         "Positivity",
         "Spiritual",
         "Success",
         "Trust",
         "Wisdom"
        ]
        return titles
    }
    
    static var topics:[Topic] {
        let topics = Topic.topicTitles.map { title -> Topic in
            let topic = Topic(title: title)
            return topic
        }
        return topics
    }
}
