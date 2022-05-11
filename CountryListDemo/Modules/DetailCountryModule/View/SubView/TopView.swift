//
//  TopView.swift
//  CountryListDemo
//
//  Created by Ivan Lugantsov on 10.05.2022.
//

import UIKit

class TopView: UIView {
    
    private lazy var capital: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubViews()
        setConstraints()
        layer.masksToBounds = false
        layer.cornerRadius = 12
        layer.borderColor = UIColor.white.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 3
        backgroundColor = .white
    }
    
    private func addSubViews() {
        addSubview(capital)
    }
    
    private func setConstraints() {
        capital.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func setData(data: CountryModel) {
        capital.attributedText = setValueToLabel(key: "Capital: ", value: data.capital?.first)
    }
    
    private func setValueToLabel(key: String, value: String?) -> NSMutableAttributedString {
        guard value?.isEmpty == false else { return NSMutableAttributedString() }
        let text = NSMutableAttributedString()
        text.append(NSAttributedString(
            string: key,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        text.append(NSAttributedString(
            string: value ?? "",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]))
        return text
    }
}
