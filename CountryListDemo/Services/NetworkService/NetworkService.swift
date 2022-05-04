//
//  NetworkService.swift
//  client
//
//  Created by Anastas Smekh on 11.08.2021.
//

import Foundation
import Alamofire
import FirebaseCrashlytics
import PDFKit

final class NetworkService {
    
    static let shared: NetworkService = {
        let instance = NetworkService()
        return instance
    }()
    
    let locker = NSLock()
    var isRefreshing = false
    var completions: [(RetryResult) -> Void] = []
    let storageRepository: StorageRepository = .init()
    
    private init() {}
    
    @discardableResult
    public func performRequest<T:Decodable>(route: APIRouter,
                                     completion: @escaping (Result<T, AFError>) -> Void) -> DataRequest? {
        if route.method == .get {
            guard let url = try? route.path.asURL() else {
                log.error(category: .network, message: "Can't build Request with path \(route.path)")
                return nil
            }
            let eng = URLEncoding(destination: .queryString, arrayEncoding: .noBrackets, boolEncoding: .literal)
            return AF.request(url, method: route.method, parameters: route.parameters, encoding: eng, headers: route.headers, interceptor: self).validate().responseDecodable { (response: DataResponse<T, AFError>) in
                log.debug(category: .network, message: message(by: response))
                completion(response.result)
            }
        } else {
            guard let request = route.uploadRequest else {
                log.error(category: .network, message: "Can't build Request with path \(route.path)")
                return nil
            }
            return AF.request(request).validate().responseDecodable { (response: DataResponse<T, AFError>) in
                log.debug(category: .network, message: message(by: response))
                completion(response.result)
            }
        }
    }
    
    private func mappedErrorFromData(_ data: Data?) -> ErrorModel? {
        guard let data = data else {
            return nil
        }
        return try? JSONDecoder().decode(ErrorModel.self, from: data)
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

/// Отрисовка Json
func message<T: Decodable>(by response: DataResponse<T, AFError>) -> String {
    var message = "Response: "
    if let response = response.response {
        message += response.debugDescription
    }
    if let json = json(by: response.data) {
        message += "\nJSON: "
        message += json
    }
    if response.error != nil {
        logErrorByFirebase(with: response)
    }
    return message
}
