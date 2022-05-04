//
//  CommonNetworkRouter.swift
//  customer
//
//  Created by Egor Malyshev on 30.11.2021.
//

import Foundation
import Alamofire

enum CommonNetworkRouter: APIRouter {
    
    case getBodyTypes((pageNumber: Int, pageSize: Int))
    
    var method: HTTPMethod {
        return .get
    }
    
    var headers: HTTPHeaders? {
        let headers: HTTPHeaders = [
            "Authorization": bearer,
            "accept": "*/*",
            "Content-Type": "application/json"
        ]
        return headers
    }
    
    var parameters: Parameters? {
        var params: Parameters = [:]
        switch self {
        
        case .getBodyTypes(let data):
            params["pageNumber"] = data.pageNumber
            params["pageSize"] = data.pageSize
        }
        return params
    }
    
    var servicePath: String {
        return "v1/common/"
    }
    
    var body: Data? {
        return nil
    }
    
    var path: String {
        var path = ""
        switch self {
        case .getBodyTypes:
            path = "body-types-list"
        }
        return Constants.baseUrl + servicePath + path
    }
}

