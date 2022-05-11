//
//  NetworkErrorView.swift
//  CountryListDemo
//
//  Created by Ivan Lugantsov on 11.05.2022.
//

import UIKit

class NetworkErrorView: UIView {
    
    private lazy var vStack = UIStackView()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "plugImage")
        view.contentMode = .scaleAspectFit
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .lightGray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(_ text: String?) {
        titleLabel.text = text ?? "Что-то пошло не так!"
    }
    
    func setImage(_ image: UIImage) {
        imageView.image = image
    }
    
    private func configure() {
        addSubviews()
        makeConstraints()
    }
    
    private func addSubviews() {
        vStack.axis = .vertical
        vStack.spacing = 13
        vStack.addArrangedSubview(imageView)
        vStack.addArrangedSubview(titleLabel)
        addSubview(vStack)
    }
    
    private func makeConstraints() {
        vStack.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
    }
}

