//
//  CountriesNetworkRouter.swift
//  CountryListDemo
//
//  Created by Ivan Lugantsov on 07.05.2022.
//

import Foundation
import Alamofire

enum CountriesNetworkRouter: APIRouter {
    
    case fetchCountryList
    case fetchCountry(id: String)
    
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
        case .fetchCountryList, .fetchCountry:
            return nil
        }
        return params
    }
    
    var servicePath: String {
        return "/v3.1/"
    }
    
    var body: Data? {
        return nil
    }
    
    var path: String {
        var path = ""
        switch self {
        case .fetchCountryList:
            path = "all"
        case .fetchCountry(let id):
            path = "alpha/\(id)"
        }
        return Constants.countryDetailsBase + servicePath + path
    }
}
