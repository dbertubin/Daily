//
//  RequestController.swift
//  Daily
//
//  Created by Derek Bertubin on 8/7/18.
//  Copyright © 2018 Derek Bertubin. All rights reserved.
//

import Foundation

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
    func requestQuotes(maximumResultCount: Int, imageSize: QuotesEndpointParameters.ImageSize, topic: String, completion: @escaping (_ error: Error?, _ quotes: [Quote]?) -> Void)  {
        let endpointParameters = QuotesEndpointParameters(maximumResultCount: maximumResultCount, imageSize: imageSize, topic: topic)
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
                
                let jsonObject = try? JSONSerialization.jsonObject(with: data, options: [])
                print(jsonObject)
                
                print("Error: Couldn't decode data into Blog")
                return
            }
            completion(nil, topics)
        }
    }
}


protocol URLQueryParameterStringConvertible {
    var queryParameters: String {get}
}

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

extension URL {
    func appendingQueryParameters(_ parametersDictionary : Dictionary<String, String>) -> URL {
        let URLString : String = String(format: "%@?%@", self.absoluteString, parametersDictionary.queryParameters)
        return URL(string: URLString)!
    }
}

protocol Endpoint {
        var baseURL: String { get set } // https://example.com
        var path: String { get set} // /users/
        var method: HTTPMethod { get set } // .get
        var url: URL? {get set}
        var headers: HTTPHeaders { get set }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

//MARK: - //MARK: -
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

//MARK: - TopicsEndpoint
struct TopicsEndpoint: Endpoint {
    var url: URL?
    var headers = HTTPHeaders()
    var method: HTTPMethod = .get
    var baseURL: String = "https://healthruwords.p.mashape.com/v1/"
    var path: String = "topics/"
    
    init() {
        url = URL(string: baseURL + path)
    }
}

//MARK: - QuotesEndpointParameters
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
    
    init(maximumResultCount: Int, imageSize: ImageSize, topic: String) {
        self.maximumResultCount = maximumResultCount
        self.imageSize = imageSize
        self.topic = topic
    }
}

//MARK: - HTTPHeaders
struct HTTPHeaders {
    var payload: [String:String] {
        var payload = [String:String]()
        payload["X-Mashape-Key"] = "eJS0RnuYe0mshJxCMi2KWneR8MFRp1zWokKjsnqR9Id2NUqXd9"
        payload["Accept"] = "application/json"
        return payload
    }
}

//MARK: - Request
struct Request {
    var endpoint: Endpoint
    init(for endpoint: Endpoint) {
        self.endpoint = endpoint
        
    }
    func urlRequest() -> URLRequest? {
        guard let url = endpoint.url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers.payload
        return request 
    }
}


