//
//  LogWriter.swift
//  client
//
//  Created by Egor Malyshev on 14.09.2021.
//

import Foundation
import os

protocol LogWriter {
    func writeMessage(_ message: String, logLevel: LogLevel)
}

class OSLogWriter: LogWriter {
    
    let log: OSLog

    init(subsystem: String, category: String) {
        log = OSLog(subsystem: subsystem, category: category)
    }

    func writeMessage(_ message: String, logLevel: LogLevel) {
        os_log("%{public}@", log: log, type: logLevel.asOSLogType ?? .default, message)
    }

}

fileprivate extension LogLevel {
    
    var asOSLogType: OSLogType? {
        switch self {
        case .info, .debug:
            return .info
        case .default:
            return .default
        case .error:
            return .error
        case .fault:
            return .fault
        default:
            return nil
        }
    }
    
}
