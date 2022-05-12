//
//  CurtainView.swift
//  CountryListDemo
//
//  Created by Ivan Lugantsov on 10.05.2022.
//

import UIKit

protocol CurtainViewProtocol: AnyObject {
    var model: [CurtainDataModel] { get }
    func toggleExpansionOfType(with index: Int)
}

class CurtainView: UIView {
    
    var output: CurtainViewProtocol?
    var previousIndexPath: IndexPath?
            
    var height: CGFloat {
         self.tableView.contentSize.height
    }
        
    private lazy var topView: TopView = {
        let view = TopView()
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellWithClass: DatailsTableViewCell.self)
        tableView.showsVerticalScrollIndicator = false
        tableView.bounces = false
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    convenience init() {
        self.init(frame: .zero)
        configure()
    }
    
    private func configure() {
        addSubViews()
        setConstraints()
    }
    
    private func addSubViews() {
        addSubview(topView)
        addSubview(tableView)
    }
    
    private func setConstraints() {
        
        topView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(self.snp.top).inset(20)
            make.width.equalToSuperview().offset(8)
            make.height.equalTo(60)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(8)
            make.height.equalTo(height)
            make.left.bottom.right.equalToSuperview()
        }
    }
    
    func setData(data: CountryModel) {
        topView.setData(data: data)
    }
    
    func reloadData() {
        tableView.reloadData()
        tableViewRemake()
    }
    
    func tableViewRemake() {
        tableView.snp.remakeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(8)
            make.height.equalTo(height)
            make.left.bottom.right.equalToSuperview()
        }
    }
}

extension CurtainView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = output?.model[indexPath.section]
        if model?.children?.isEmpty == false && indexPath.row == 0 {
            output?.toggleExpansionOfType(with: indexPath.section)
            if let indexPath = previousIndexPath {
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
            tableView.reloadSections([indexPath.section], with: .fade)
            tableViewRemake()
        } else {
            if model?.children?.isEmpty == false, tableView.cellForRow(at: IndexPath(row: 0, section: indexPath.section)) != nil {
                tableView.reloadRows(at: [IndexPath(row: 0, section: indexPath.section)], with: .none)
                tableViewRemake()
            }
        }
    }
}

extension CurtainView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        output?.model.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let children = output?.model[section].children, output?.model[section].isExpanded == true {
            return children.count + 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DatailsTableViewCell = tableView.dequeueCell(at: indexPath)
        
        guard let model = output?.model else { return UITableViewCell() }
        
        if indexPath.row == 0 {
            cell.allowsMultipleSelection = true
            cell.getData(model[indexPath.section], child: "", isParrent: true)
            return cell
        } else {
            guard let model = output?.model[indexPath.section],
                  let children = model.children?[indexPath.row - 1] else { return UITableViewCell() }
            cell.getData(model, child: children, isParrent: false)
        }
        return cell
    }
}
