//
//  ServerConfiguration.swift
//  customer
//
//  Created by Egor Malyshev on 19.04.2022.
//

import Foundation

final class ServerConfiguration {
    
    static let shared: ServerConfiguration = .init()
    
    private var config: ServerConfigurationType = .dev
    
    private init() {}
    
    public func setConfiguration(_ type: ServerConfigurationType) {
        self.config = type
    }
    
    public var name: String {
        config.name
    }
    
    public var baseUrl: String {
        config.baseUrl
    }
    
    public var wsUrl: String {
        config.wsUrl
    }
    
    public var shareLink: String {
        config.shareLink
    }
    
    public var agreementLink: String {
        config.agreementLink
    }
}

enum ServerConfigurationType: String, CaseIterable {
    case dev, stage, prod
    
    var name: String {
        switch self {
        case .dev:
            return "Dev"
        case .stage:
            return "Stage"
        case .prod:
            return "Prod"
        }
    }
    
    var baseUrl: String {
        switch self {
        case .dev:
            return "https://api-gruzoperevozki-dev.umbrellait.tech/"
        case .stage:
            return "https://api-gruzoperevozki-sg.umbrellait.tech/"
        case .prod:
            return "https://api.strekoza.one/"
        }
    }
    
    var wsUrl: String {
        switch self {
        case .dev:
            return "wss://api-gruzoperevozki-dev.umbrellait.tech/ws"
        case .stage:
            return "wss://api-gruzoperevozki-sg.umbrellait.tech/ws"
        case .prod:
            return "wss://api.strekoza.one/ws"
        }
    }
    
    var shareLink: String {
        switch self {
        case .dev:
            return "https://gruzoperevozki-dev.umbrellait.tech/"
        case .stage:
            return "https://gruzoperevozki-sg.umbrellait.tech/"
        case .prod:
            return "https://api.strekoza.one/"
        }
    }
    
    var agreementLink: String {
        switch self {
        case .dev:
            return "https://gruzoperevozki-dev.umbrellait.tech/legal"
        case .stage:
            return "https://gruzoperevozki-sg.umbrellait.tech/legal"
        case .prod:
            return "https://strekoza.one/legal"
        }
    }
}
