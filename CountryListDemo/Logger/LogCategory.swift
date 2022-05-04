//
//  LogCategory.swift
//  client
//
//  Created by Egor Malyshev on 14.09.2021.
//

import Foundation

public enum LogCategory: String, CaseIterable {
    
    case general
    case network
    case authorization
    case map
    
    var emoji: String {
        switch self {
        case .general:
            return "🤖"
        case .network:
            return "📡"
        case .authorization:
            return "👁"
        case .map:
            return "🗺"
        }
    }
    
}
