//
//  StorageManager.swift
//  CountryListDemo
//
//  Created by Ivan Lugantsov on 11.05.2022.
//

import UIKit
import CoreData

class StorageManager<T: NSManagedObject> {
    
    private let persistentContainer: NSPersistentContainer = {
        let fileName = "CountryListDemo"
        let container = NSPersistentContainer(name: fileName)
        container.loadPersistentStores { storeDescriprion, error in
            if let error = error as NSError? {
                fatalError("Unreserved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    private let viewContext: NSManagedObjectContext
    
    init() {
        viewContext = persistentContainer.viewContext
    }
    
    // MARK: - Public Methods
    public func fetchData(completion: (Result<[T], Error>) -> Void) {
        
        let fetchRequest: NSFetchRequest<T> = T().fetchRequest()
        do {
            let data = try viewContext.fetch(fetchRequest)
            completion(.success(data))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    public func save<U: Codable>(data: U) {
        let product = T(context: viewContext)
        let mirrorNewValue = Mirror(reflecting: data)
        
        for newValue in mirrorNewValue.children {
            if let key = newValue.label {
                product.setValue(newValue.value, forKey: key)
                print("Save")
            }
        }
        saveContext()
    }
    
    public func edit<U: Codable>(model: T, data: U) {
        let mirrorNewValue = Mirror(reflecting: data)
        
        var isSave = false
        
        for newValue in mirrorNewValue.children {
            if let key = newValue.label {
                model.setValue(newValue.value, forKey: key)
                isSave = true
            }
        }
        if isSave {
            saveContext()
        }
    }
    
    public func delete(data: T) {
        viewContext.delete(data)
        saveContext()
    }
    
    // MARK: - Core Data Saving Support
    private func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unreserved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

extension NSManagedObject {
    
    func fetchRequest<T>() -> NSFetchRequest<T> {
        return NSFetchRequest<T>(entityName: String(describing: T.self))
    }
}
