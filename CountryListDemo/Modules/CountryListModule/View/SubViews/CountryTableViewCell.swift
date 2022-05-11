//
//  CountryTableViewCell.swift
//  CountryListDemo
//
//  Created by Ivan Lugantsov on 09.05.2022.
//

import UIKit

class CountryTableViewCell: UITableViewCell {
        
    private lazy var countryView: CountryCellView = {
        let view = CountryCellView()
        return view
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
        countryView.prepareForReuse()
    }
    
    private func configure() {
        selectionStyle = .none
        addSubView()
        setContraints()
    }
    
    private func addSubView() {
        contentView.addSubview(countryView)
    }
    
    private func setContraints() {
        countryView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
    
    func setData(data: CountryModel) {
        countryView.setData(data: data)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        animateSelected(is: selected)
    }
    
    private func animateSelected(is selected: Bool) {
        if selected {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) { [weak self] in
                self?.countryView.transform = .init(scaleX: 0.9, y: 0.9)
            } completion: { value in
                UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveEaseInOut) { [weak self] in
                    self?.countryView.transform = .identity
                }
            }
        }
    }
}

extension CountryTableViewCell {
    
    func getSnapshot() -> UIView? {
        return countryView.getSnapshot()
    }

    func convertImage(to coordinateSpace: UICoordinateSpace) -> CGRect {
        return countryView.convertImage(to: coordinateSpace)
    }
}

