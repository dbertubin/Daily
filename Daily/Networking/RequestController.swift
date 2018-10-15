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
    
    //FIXME: Add throws
    func request(_ request: Request,  completion: @escaping (_ error: Error?, _ data: Data?) -> Void) {
        guard let request = request.urlRequest() else {
            return
        }
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            //FIXME: Add throws
            guard error == nil else {
                completion(error, .none)
                return
            }
            
            //FIXME: Handle Error codes
            //let statusCode = (response as! HTTPURLResponse).statusCode
            
            //FIXME: Add throws
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
    //FIXME: Add throws
    func requestQuote(with parameters: QuoteEndpointParameters? = nil, completion: @escaping (_ error: Error?, _ quote: Quote?) -> Void) {
        
        let tssRequest = Request(for: QuoteEndpoint(parameters: parameters))
        
        request(tssRequest) { error, data in
            //FIXME: Add throws
            guard error == nil else {
                completion(error, nil)
                return
            }
            //FIXME: Add throws
            guard let data = data else {
                completion(nil, nil)
                return
            }
            //Possibly move this to a parser
            //FIXME: Add throws
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                return
            }
            //FIXME: Add throws
            guard let contentsJson = json?["contents"] else {
                return
            }
            
            //FIXME: Add throws
            guard let contentsData = try? JSONSerialization.data(withJSONObject: contentsJson as Any, options: []) as Data else {
                return
            }
            
            //FIXME: Add throws
            guard let response = try? JSONDecoder().decode(Quote.self, from: contentsData) else {
                print("Error: Couldn't decode data into Blog")
                return
            }
            completion(nil, response)
        }
    }
}

extension RequestController {
    func requestCategories(with parameters: CategoryEndpointParameters? = nil, completion: @escaping (_ error: Error?, _ categories: [Category]?) -> Void) {
        
        let tssRequest = Request(for: CategoryEndpoint(parameters: parameters))
        
        request(tssRequest) { error, data in
            guard error == nil else {
                completion(error, nil)
                return
            }
            guard let data = data else {
                completion(nil, nil)
                return
            }
            
            // This goes in a parser  
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                return
            }
            
            guard let contentsJson = json?["contents"] as? [String: Any] else {
                return
            }
            
            guard let categoryJson = contentsJson["categories"] as? [String: String] else {
                return
            }
            
            let response = categoryJson.map { key, value in
                Category(key: key, value: value)
            }
            
            completion(nil, response)
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
        payload["X-TheySaidSo-Api-Secret"] = "_vYeAJPnTbQxoJVsO6s3lgeF"
        return payload
    }
}




