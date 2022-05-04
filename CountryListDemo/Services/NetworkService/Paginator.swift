//
//  PaginatorType.swift
//  client
//
//  Created by Ivan Lugantsov on 30.09.2021.
//

import Foundation
import Alamofire

class Paginator<T: Codable> {
    var total: Int = 0
    var currentOffset: Int = 0
    var pageSize: Int = 10
    var limit: Int = 10
    var page: Int = 1
    var isNeedAddDetail: Bool = true
    var previousRequest: DataRequest?
    var requestClosure: (_ page: Int, _ offset: Int, @escaping (Result<FetchRequest<T>, AFError>) -> Void) -> DataRequest?
    var onSuccess: (([T]) -> Void)? {
        didSet {
            onSuccess?(storedData)
        }
    }
    var onError: ((AFError) -> Void)?
    var storedData: [T] = []

    init(
        requestClosure: @escaping (_ page: Int, _ offset: Int, @escaping (Result<FetchRequest<T>, AFError>) -> Void) -> DataRequest?,
        onSuccess: (([T]) -> Void)? = nil,
        onError: ((AFError) -> Void)? = nil
    ) {
        self.requestClosure = requestClosure
        self.onSuccess = onSuccess
        self.onError = onError
    }

    func fetchNextPage() {
      //  guard currentOffset <= total else { return }
        guard isNeedAddDetail else { return }
        isNeedAddDetail = false
        sendRequest()
    }

    func reloadData() {
        storedData = []
        currentOffset = 0
        page = 1
        previousRequest?.cancel()
        sendRequest()
    }

    private func sendRequest() {
        previousRequest = requestClosure(page, pageSize) { [weak self] data in
            switch data {
            case .success(let data):
                guard let results = data.data else { return }
                self?.storedData.append(contentsOf: results)
                self?.currentOffset += self?.limit ?? 10
                self?.page += 1
               // self?.total = data.totalElements ?? 0
                self?.onSuccess?(self?.storedData ?? [])
            case .failure(let error):
                print(error.localizedDescription)
                self?.onError?(error)
            }
            self?.isNeedAddDetail = true
        }
    }
}

struct FetchRequest<T: Codable>: Codable {
    let data: [T]?
    var links: Links?
    var meta: Meta?
}
