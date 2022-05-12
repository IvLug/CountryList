//
//  RegionTableVIewCell.swift
//  CountryListDemo
//
//  Created by Ivan Lugantsov on 12.05.2022.
//

import UIKit

class RegionTableVIewCell: UITableViewCell {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private lazy var arrowImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "arrow")
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
    }
    
    private func configure() {
        addSubviews()
        makeConstraints()
        selectionStyle = .none
    }
    
    private func addSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(arrowImage)
    }
    
    private func makeConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(30)
            make.left.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        arrowImage.snp.makeConstraints { make in
            make.width.equalTo(10)
            make.height.equalTo(18)
            make.right.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }
    
    func setData(data: String) {
        titleLabel.text = data
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        animateSelected(is: selected)
    }
    
    private func animateSelected(is selected: Bool) {
        if selected {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) { [weak self] in
                self?.transform = .init(scaleX: 0.9, y: 0.9)
                self?.contentView.alpha = 0
            } completion: { value in
                UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveEaseInOut) { [weak self] in
                    self?.transform = .identity
                    self?.contentView.alpha = 1
                }
            }
        }
    }
}
