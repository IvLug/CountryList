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
    case searchCountry(name: String)
    case fetchCountriesInRegion(_ region: String)
    
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
        return nil
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
        case .searchCountry(let name):
            path = "name/\(name)"
        case .fetchCountriesInRegion(let region):
            path = "region/\(region)"
        }
        return Constants.countryDetailsBase + servicePath + path
    }
}
