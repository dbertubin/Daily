//
//  RequestController.swift
//  Daily
//
//  Created by Derek Bertubin on 8/7/18.
//  Copyright © 2018 Derek Bertubin. All rights reserved.
//

import Foundation

protocol RequestControllerRequired {
    var requestController: RequestController { get }
}

class RequestController {
    
    var sessionConfiguration: URLSessionConfiguration {
        return .default
    }
    var session: URLSession {
        let session = URLSession(configuration: sessionConfiguration, delegate: nil, delegateQueue: nil)
        return session
    }
    
    func request(_ request: Request,  completion: @escaping (_ error: Error?, _ data: Data?) -> Void) {
        guard let request = request.urlRequest() else {
            return
        }
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard error == nil else {
                completion(error, .none)
                return
            }
            
            let statusCode = (response as! HTTPURLResponse).statusCode
            print("URL Session Task Succeeded: HTTP \(statusCode)")
            
            guard let data = data else {
                print("Error: No data to decode")
                return
            }
            completion(.none, data)
            
        })
        task.resume()
        session.finishTasksAndInvalidate()
    }
}

extension RequestController {
    func requestQuotes(maximumResultCount: Int, imageSize: QuotesEndpointParameters.ImageSize, topic: Topic? = nil, completion: @escaping (_ error: Error?, _ quotes: [Quote]?) -> Void)  {
        
        let endpointParameters = QuotesEndpointParameters(maximumResultCount: maximumResultCount, imageSize: imageSize, topic: topic?.title)
        let quotesEndPoint = QuotesEndpoint(parameters: endpointParameters)
        let quotesRequest = Request(for: quotesEndPoint)
        request(quotesRequest) { error, data in
            guard error == nil else {
                completion(error, nil)
                return
            }
            guard let data = data else {
                completion(nil, nil)
                return
            }
            guard let quotes = try? JSONDecoder().decode([Quote].self, from: data) else {
                print("Error: Couldn't decode data into Blog")
                return
            }
            completion(nil, quotes)
        }
    }
}

extension RequestController {
    func requestTopics(completion: @escaping (_ error: Error?, _ topics: [Topic]?) -> Void)  {
        let topicsEndpoint = TopicsEndpoint()
        let topicsRequest = Request(for: topicsEndpoint)
        request(topicsRequest) { error, data in
            guard error == nil else {
                completion(error, nil)
                return
            }
            guard let data = data else {
                completion(nil, nil)
                return
            }
            guard let topics = try? JSONDecoder().decode([Topic].self, from: data) else {
                print("Error: Couldn't decode data into Blog")
                return
            }
            completion(nil, topics)
        }
    }
}

extension RequestController {
    func requestForismaticQuote(completion: @escaping (_ error: Error?, _ quote: ForismaticQuote?) -> Void) {
        let forismaticRequest = Request(for: ForismaticEndpoint())
    
        request(forismaticRequest) { error, data in
            guard error == nil else {
                completion(error, nil)
                return
            }
            guard let data = data else {
                completion(nil, nil)
                return
            }
            guard let quote = try? JSONDecoder().decode(ForismaticQuote.self, from: data) else {
                print("Error: Couldn't decode data into Blog")
                return
            }
            completion(nil, quote)
        }
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

//MARK: - HTTPHeaders
struct HTTPHeaders {
    var payload: [String:String] {
        var payload = [String:String]()
        payload["X-Mashape-Key"] = "DygPGe0RjdmshwY1r1AGm4zfT5edp1MpZuRjsnZgC1npPFT9zc"
        payload["Accept"] = "application/json"
        return payload
    }
}




