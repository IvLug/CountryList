//
//  Logger.swift
//  client
//
//  Created by Egor Malyshev on 14.09.2021.
//

import Foundation
import os

public class Logger {
    
    public var logLevel: LogLevel = .debug
        
    private enum ExecutionMethod {
        case sync(lock: NSRecursiveLock)
        case async(queue: DispatchQueue)
    }
    
    private let executionMethod: ExecutionMethod
    
    public init() {
        #if DEBUG
            executionMethod = .sync(lock: NSRecursiveLock())
        #else
            executionMethod = .async(queue: DispatchQueue(label: "Dragonfly.customer.serial.log.queue", qos: .utility))
        #endif
    }
    
    public func debug(
        category: LogCategory,
        message: String,
        fileName: String = #file,
        line: Int = #line,
        funcName: String = #function
    ) {
        log(
            level: .debug,
            category: category,
            message: message,
            fileName: fileName,
            line: line,
            funcName: funcName
        )
    }
    
    public func info(
        category: LogCategory,
        message: String,
        fileName: String = #file,
        line: Int = #line,
        funcName: String = #function
    ) {
        log(
            level: .info,
            category: category,
            message: message,
            fileName: fileName,
            line: line,
            funcName: funcName
        )
    }
    
    public func `default`(
        category: LogCategory,
        message: String,
        fileName: String = #file,
        line: Int = #line,
        funcName: String = #function
    ) {
        log(
            level: .default,
            category: category,
            message: message,
            fileName: fileName,
            line: line,
            funcName: funcName
        )
    }
    
    public func error(
        category: LogCategory,
        message: String,
        fileName: String = #file,
        line: Int = #line,
        funcName: String = #function
    ) {
        log(
            level: .error,
            category: category,
            message: message,
            fileName: fileName,
            line: line,
            funcName: funcName
        )
    }
    
    public func fault(
        category: LogCategory,
        message: String,
        fileName: String = #file,
        line: Int = #line,
        funcName: String = #function
    ) {
        log(
            level: .fault,
            category: category,
            message: message,
            fileName: fileName,
            line: line,
            funcName: funcName
        )
    }
    
    private func log(
        level: LogLevel,
        category: LogCategory,
        message: String,
        fileName: String = #file,
        line: Int = #line,
        funcName: String = #function
    ) {
        guard logLevel.rawValue >= level.rawValue else {
            return
        }
        var output = Log(message)
            .subsystem(Bundle.main.bundleIdentifier ?? "com.dragonfly.customer.undefined")
        if logLevel == .trace {
            output = output.meta(filename: fileName, line: line, funcName: funcName)
        }
        let message = output
            .level(level)
            .category(category)
            .build()
        
        log(subsystem: output.subsystem, level: level, category: category, message: message)
    }
    
    private func log(subsystem: String, level: LogLevel, category: LogCategory, message: String) {
        let categories: [LogCategory] = LogCategory.allCases
        guard categories.contains(category) else {
            return
        }
        let writer = makeWriter(subsystem: subsystem, category: category)
        switch executionMethod {
        case let .async(queue: queue):
            queue.async { writer.writeMessage(message, logLevel: level) }
        case let .sync(lock: lock):
            lock.lock(); defer { lock.unlock() }
            writer.writeMessage(message, logLevel: level)
        }
    }
    
    private func makeWriter(subsystem: String, category: LogCategory) -> LogWriter {
        return OSLogWriter(subsystem: subsystem, category: category.rawValue.capitalized)
    }
    
}
