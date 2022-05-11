//
//  AssociatedStore .swift
//  CountryListDemo
//
//  Created by Ivan Lugantsov on 10.05.2022.
//

import Foundation

public protocol AssociatedStore {}

public extension AssociatedStore {
    
    func associatedObject<T>(forKey key: UnsafeRawPointer) -> T? {
        objc_getAssociatedObject(self, key) as? T
    }
    
    func setAssociatedObject<T>(_ object: T?, forKey key: UnsafeRawPointer) {
        objc_setAssociatedObject(self, key, object, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func associatedObject<T>(forKey key: UnsafeRawPointer, default: @autoclosure () -> T) -> T {
        if let object: T = self.associatedObject(forKey: key) {
            return object
        }
        let object = `default`()
        self.setAssociatedObject(object, forKey: key)
        return object
    }
}
