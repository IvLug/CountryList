//
//  DatailsTableViewCell.swift
//  CountryListDemo
//
//  Created by Ivan Lugantsov on 10.05.2022.
//

import UIKit

class DatailsTableViewCell: UITableViewCell {
    
    var allowsMultipleSelection: Bool = false
    var isParentSelected: Bool = false
            
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var disclosureImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(disclosureImageView)

        titleLabel.snp.remakeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(UIEdgeInsets(top: 11, left: 16, bottom: 11, right: 50))
        }
        disclosureImageView.snp.makeConstraints { make in
            make.centerY.right.equalToSuperview()
            make.width.equalTo(26)
            make.height.equalTo(8)
        }
    }

    func getData(_ model: CurtainDataModel, child: String, isParrent: Bool) {
                
        if isParrent {
            disclosureImageView.isHidden = false
            titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            titleLabel.text = model.title
            disclosureImageView.image = (model.isExpanded ?? false) ? UIImage(named: "expandedArrowUp") : UIImage(named: "expandedArrow")
        } else {
            disclosureImageView.isHidden = true
            titleLabel.text = child
            titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        }
        
    }
}
