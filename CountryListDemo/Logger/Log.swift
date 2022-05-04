//
//  Log.swift
//  client
//
//  Created by Egor Malyshev on 14.09.2021.
//

import Foundation

struct Log {
        
    typealias Meta = (filename: String, line: Int, funcName: String)
    
    var subsystem: String = ""
    var category: LogCategory = .general
    var level: LogLevel = .debug
    var meta: Meta?
    var message: String = ""
    var borders: (start: String, end: String) = ("-> ", "\n<-")
    
    init(_ object: Any?) {
        message = "\(String(describing: object))"
    }
    
    init(_ object: Any) {
        message = "\(String(describing: object))"
    }
    
    func build() -> String {
        var header = ""
        header += category.emoji + " "
        header += level.emoji + " "
        if let meta = meta {
            header += "[\(Log.sourceFileName(filePath: meta.filename))]:\(meta.line) \(meta.funcName)"
        }
        return borders.start + header + "\n" + message + borders.end
    }
    
    func meta(filename: String = #file, line: Int = #line, funcName: String = #function) -> Log {
        var ret = self
        ret.meta = (filename, line, funcName)
        return ret
    }
    
    func subsystem(_ subsystem: String) -> Log {
        var ret = self
        ret.subsystem = subsystem
        return ret
    }
    
    func category(_ category: LogCategory) -> Log {
        var ret = self
        ret.category = category
        return ret
    }
    
    func level(_ type: LogLevel) -> Log {
        var ret = self
        ret.level = type
        return ret
    }
    
    func borders(start: String, end: String) -> Log {
        var ret = self
        ret.borders = (start, end)
        return ret
    }
    
}

// MARK: - Private Functions

private extension Log {
    /// Extract the file name from the file path
    ///
    /// - Parameter filePath: Full file path in bundle
    /// - Returns: File Name with extension
    static func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
}
