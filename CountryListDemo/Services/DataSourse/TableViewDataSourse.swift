//
//  TableViewDataSourse.swift
//  CountryListDemo
//
//  Created by Ivan Lugantsov on 04.05.2022.
//

import UIKit

protocol TableViewDataSourseDelegate: AnyObject {
    func setDataToCell(indexPath: IndexPath, tableView: UITableView) -> UITableViewCell
}

class TableViewDataSourse<T>: NSObject, UITableViewDataSource {
    
    public var delegate: TableViewDataSourseDelegate?
    
    private var items: [T] = []
    
    public func setData(data: [T]) {
        items = data
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return delegate?.setDataToCell(indexPath: indexPath, tableView: tableView) ?? UITableViewCell()
    }
}
