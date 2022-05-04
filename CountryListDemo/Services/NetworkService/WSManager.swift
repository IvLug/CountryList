//
//  WSManager.swift
//  customer
//
//  Created by Egor Malyshev on 11.01.2022.
//

import Foundation
import StompClientLib

protocol WSManagerDelegate: AnyObject {
    func didConnect()
    func didDisconnect()
    func didReceivedError(withMessage message: String)
    func didReceivedMessage(_ message: String?, jsonBody: AnyObject?)
}

class WSManager {
    
    weak var delegate: WSManagerDelegate?
    
    private let socketClient: StompClientLib = StompClientLib()
    private let path: String
    
    var isConnected: Bool {
        return socketClient.isConnected()
    }
    
    init(path: String) {
        self.path = path
    }
    
    deinit {
        socketClient.disconnect()
    }
    
    func sendMessage<T: Codable>(topic: String, message: T, headers: [String: String]?, receipt: String?) -> Void {
        guard let jsonMessage = try? String(data: JSONEncoder().encode(message), encoding: .utf8) else { return }
        socketClient.sendMessage(
            message: jsonMessage,
            toDestination: topic,
            withHeaders: headers,
            withReceipt: receipt
        )
    }
    
    func connect() {
        guard let url = URL(string: path) else {
            log.error(category: .network, message: "Can't build request with url: \(path)")
            return
        }
        let request = NSURLRequest(url: url)
        socketClient.openSocketWithURLRequest(request: request, delegate: self)
        socketClient.reconnect(request: request, delegate: self, time: 15.0)
    }
    
    func subscribe(destination: String) {
        socketClient.subscribe(destination: destination)
    }
    
    func disconnect() {
        socketClient.stopReconnect()
        socketClient.disconnect()
    }
    
}

extension WSManager: StompClientLibDelegate {
    func stompClient(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: AnyObject?, akaStringBody stringBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
        log.debug(category: .network, message: "#WS did received message: \(stringBody ?? "")")
        delegate?.didReceivedMessage(stringBody, jsonBody: jsonBody)
    }
    
    func stompClientDidDisconnect(client: StompClientLib!) {
        log.debug(category: .network, message: "#WS did disconnect")
        client.connection = false
        delegate?.didDisconnect()
    }
    
    func stompClientDidConnect(client: StompClientLib!) {
        log.debug(category: .network, message: "#WS did connect")
        delegate?.didConnect()
    }
    
    func serverDidSendReceipt(client: StompClientLib!, withReceiptId receiptId: String) {}
    
    func serverDidSendError(client: StompClientLib!, withErrorMessage description: String, detailedErrorMessage message: String?) {
        log.error(category: .network, message: "#WS did send error: \(description)")
        delegate?.didReceivedError(withMessage: description)
    }
    
    func serverDidSendPing() {}
    
}

struct WebSocketMessage<Body: Codable>: Codable {
    let errorCode: String?
    let errorMessage: String?
    let body: Body?
}
