//
//  APIRouter.swift
//  client
//
//  Created by Anastas Smekh on 11.08.2021.
//

import Foundation
import Alamofire

protocol APIRouter {
    
    var method: HTTPMethod { get }
    
    var headers: HTTPHeaders? { get }
    
    var parameters: Parameters? { get }
    
    var servicePath: String { get }
    
    var path: String { get }
    
    var body: Data? { get }
    
    var request: URLRequestConvertible? { get }
}

extension APIRouter {
    
    private var token: String {
        return ""
    }
    
    public var bearer: String {
        return "Bearer \(token)"
    }
    
    var request: URLRequestConvertible? {
        guard let url = try? path.asURL() else {
            log.error(category: .network, message: "Не удается построить запрос с помощью \(path)")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        headers?.forEach({ headers in
            request.addValue(headers.value, forHTTPHeaderField: headers.name)
        })
        
        if let body = body {
            request.httpBody = body
        } else if let params = parameters, method != .get {
            let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
            request.httpBody = jsonData
        }
        
        return request
    }
    
    var uploadRequest: URLRequestConvertible? {
        guard let url = try? path.asURL() else {
            log.error(category: .network, message: "Не удается построить запрос с помощью \(path)")
            return nil
        }
        var components = URLComponents(string: url.absoluteString)
        components?.queryItems = queryItems(by: parameters as? [String: CustomStringConvertible])
        var request: URLRequest
        if let urlWithParams = components?.url {
            request = URLRequest(url: urlWithParams)
        } else {
            request = URLRequest(url: url)
        }
        
        request.httpMethod = method.rawValue
        headers?.forEach({ headers in
            request.addValue(headers.value, forHTTPHeaderField: headers.name)
        })
        request.httpBody = body
        
        return request

    }
    
    private func queryItems(by parameters: [String: CustomStringConvertible]?) -> [URLQueryItem]? {
        return parameters?.filter({!($0.value is Data)}).compactMap({ URLQueryItem(name: $0.key, value: $0.value.description) })
    }
}
