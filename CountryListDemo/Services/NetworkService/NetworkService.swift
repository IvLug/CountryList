//
//  NetworkService.swift
//  client
//
//  Created by Anastas Smekh on 11.08.2021.
//

import Foundation
import Alamofire
import PDFKit

final class NetworkService: RequestInterceptor {
    
    static let shared: NetworkService = {
        let instance = NetworkService()
        return instance
    }()
    
    let locker = NSLock()
    var isRefreshing = false
    var completions: [(RetryResult) -> Void] = []
    
    init() {}
    
    @discardableResult
    public func performRequest<T:Decodable>(route: APIRouter,
                                     completion: @escaping (Error?, DataResponse<T, AFError>) -> Void) -> DataRequest? {
        if route.method == .get {
            guard let url = try? route.path.asURL() else {
                log.error(category: .network, message: "Can't build Request with path \(route.path)")
                return nil
            }
            let eng = URLEncoding(destination: .queryString, arrayEncoding: .noBrackets, boolEncoding: .literal)
            return AF.request(url, method: route.method, parameters: route.parameters, encoding: eng, headers: route.headers, interceptor: self).validate().responseDecodable { [weak self] (response: DataResponse<T, AFError>) in
                log.debug(category: .network, message: message(by: response))
                guard let mappedError = self?.processingError(decoder: JSONDecoder(), response: response) else {
                    completion(nil, response)
                    return
                }
                completion(mappedError.error, response)
            }
        } else {
            guard let request = route.uploadRequest else {
                log.error(category: .network, message: "Can't build Request with path \(route.path)")
                return nil
            }
            return AF.request(request).validate().responseDecodable { [weak self] (response: DataResponse<T, AFError>) in
                log.debug(category: .network, message: message(by: response))
                guard let mappedError = self?.processingError(decoder: JSONDecoder(), response: response) else {
                    completion(nil, response)
                    return
                }
                completion(mappedError.error, response)
            }
        }
    }
    
    public func fetchImage(urlStr: String, completion: @escaping (Data) -> Void) {
        AF.request(urlStr).responseData { response in
            switch response.result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func processingError<T: Decodable>(decoder: JSONDecoder?, response: DataResponse<T, AFError>) -> (error: Error?, response: Result<T, AFError>) {
        guard let data = response.data else {
            return (nil, response.result)
        }
        do {
            let errorMapped = try decoder?.decode(ErrorModel.self, from: data)
            return (errorMapped, response.result)
        } catch let error {
            print("Parsing Error: \(error)")
            return (error, response.result)
        }
    }
}

private func json(by data: Data?) -> String? {
    if
        let data = data,
        let json = try? JSONSerialization.jsonObject(with: data, options: []),
        let serializedData = try? JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted]),
        let encoded = String(data: serializedData, encoding: String.Encoding.utf8) {
        return encoded
    }
    return nil
}

/// ?????????????????? Json
func message<T: Decodable>(by response: DataResponse<T, AFError>) -> String {
    var message = "Response: "
    if let response = response.response {
        message += response.debugDescription
    }
    if let json = json(by: response.data) {
        message += "\nJSON: "
        message += json
    }
    return message
}
