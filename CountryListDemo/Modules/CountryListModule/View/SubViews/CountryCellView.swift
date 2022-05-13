//
//  CountryCellView.swift
//  CountryListDemo
//
//  Created by Ivan Lugantsov on 09.05.2022.
//

import UIKit

class CountryCellView: UIView {
    
    private lazy var countryNameLat: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var countryName: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var capital: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var flagImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.kf.isActiveIndicator = true
        return imageView
    }()
    
    private lazy var continentsTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        return view
    }()
    
    private lazy var hStack: UIStackView = {
        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.alignment = .top
        hStack.distribution = .fillProportionally
        return hStack
    }()
    
    private lazy var vStack: UIStackView = {
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.alignment = .leading
        vStack.tag = 10
        return vStack
    }()
    
    private lazy var languages: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    private lazy var bacgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.6
        view.layer.shadowRadius = 4
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareForReuse() {
        countryNameLat.text = ""
        countryName.text = ""
        capital.text = ""
        flagImage.image = nil
        languages.text = ""
        stackView.subviews.forEach { view in
            let label = view as? UILabel
            label?.text = ""
            view.removeFromSuperview()
        }
        
        hStack.subviews.forEach { view in
            view.removeFromSuperview()
        }
        
        vStack.subviews.forEach({ view in
            let label = view as? UILabel
            label?.text = ""
            view.removeFromSuperview()
        })
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
        addSubview(flagImage)
        addSubview(bacgroundView)
        bacgroundView.addSubview(countryNameLat)
        bacgroundView.addSubview(countryName)
        bacgroundView.addSubview(stackView)
    }
    
    private func setConstraints() {
        
        countryNameLat.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
        }
        countryName.snp.makeConstraints { make in
            make.top.equalTo(countryNameLat.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
        }
        flagImage.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(140)
        }
        stackView.snp.makeConstraints { make in
            make.top.equalTo(countryName.snp.bottom).offset(8)
            make.bottom.right.left.equalToSuperview().inset(8)
        }
        bacgroundView.snp.makeConstraints { make in
            make.top.equalTo(flagImage.snp.bottom).inset(12)
            make.bottom.right.equalToSuperview().offset(4)
            make.left.equalToSuperview().offset(-4)
        }
    }
    
    func setData(data: CountryModel) {
        stackView.addArrangedSubview(capital)
        stackView.addArrangedSubview(continentsTitle)
        countryNameLat.text = data.name?.official
        countryName.text = data.name?.nativeName?.first?.value.official
        capital.attributedText = setValueToLabel(key: "Capital: ", value: data.capital?.first)
        continentsTitle.attributedText = setValueToLabel(key: "Continent: ", value: data.continents?.first)
        
        if let languages = data.languages {
            self.languages.text = continentsCount(count: languages.count)
        }
        
        flagImage.kf.loadImage(urlStr: data.flags?.png ?? "")
        setlanguages(data: data)
        stackView.layoutIfNeeded()
    }
    
    func setlanguages(data: CountryModel) {
        
        hStack.addArrangedSubview(languages)
        hStack.addArrangedSubview(vStack)
        
        languages.snp.makeConstraints { make in
            make.width.equalTo(90)
        }
        
        data.languages?.forEach({ (key, value) in
            let label = UILabel()
            label.textAlignment = .left
            label.font = UIFont.systemFont(ofSize: 16)
            label.text = value
            vStack.addArrangedSubview(label)
        })
        stackView.addArrangedSubview(hStack)
        
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
    
    func getSnapshot() -> UIView? {
        return flagImage.snapshotView(afterScreenUpdates: false)
    }

    func convertImage(to coordinateSpace: UICoordinateSpace) -> CGRect {
        return flagImage.convert(flagImage.bounds, to: coordinateSpace)
    }
}
