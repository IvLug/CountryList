//
//  LogLevel.swift
//  client
//
//  Created by Egor Malyshev on 14.09.2021.
//

import Foundation

public enum LogLevel: Int, CaseIterable, Comparable, Equatable {
    
    case none = 0
    case debug
    case info
    case `default`
    case error
    case fault
    case trace
    
    var emoji: String {
        switch self {
        case .none:
            return ""
        case .debug:
            return "[🪲]"
        case .info:
            return "[ℹ️]"
        case .`default`:
            return "[💡]"
        case .error:
            return "[⚠️]"
        case .fault:
            return "[‼️]"
        case .trace:
            return "[🔍]"
        }
    }
    
    public static func < (lhs: LogLevel, rhs: LogLevel) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
}
