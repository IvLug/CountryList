//
//  Extension+UISearchBar.swift
//  CountryListDemo
//
//  Created by Ivan Lugantsov on 11.05.2022.
//

import UIKit

extension UISearchBar {
    
    func clearBackgroundColor() {
        guard let UISearchBarBackground: AnyClass = NSClassFromString("UISearchBarBackground") else { return }
        
        for view in subviews {
            for subview in view.subviews where subview.isKind(of: UISearchBarBackground) {
                subview.alpha = 0
            }
        }
    }
    
    func setRightImage(normalImage: UIImage,
                       highLightedImage: UIImage) {
        showsBookmarkButton = true
        if let btn = searchTextField.rightView as? UIButton {
            btn.setImage(normalImage,
                         for: .normal)
            btn.setImage(highLightedImage,
                         for: .highlighted)
        }
    }
    
    func setLeftImage(_ image: UIImage,
                      with padding: CGFloat = 0,
                      tintColor: UIColor) {
        let imageView = UIImageView()
        imageView.image = image
        imageView.tintColor = tintColor
        
        imageView.snp.makeConstraints {
            $0.size.equalTo(20)
        }
        
        if padding != 0 {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.alignment = .center
            stackView.distribution = .fill
            
            stackView.addArrangedSubview(paddingView())
            stackView.addArrangedSubview(imageView)
            stackView.addArrangedSubview(paddingView())

            searchTextField.leftView = stackView
        } else {
            searchTextField.leftView = imageView
        }
        func paddingView() -> UIView {
            let paddingView = UIView()
            
            paddingView.snp.makeConstraints {
                $0.width.height.equalTo(padding)
            }
            return paddingView
        }
    }
    
    func setTextFieldColor(_ color: UIColor) {
        clearBackgroundColor()
        searchTextField.backgroundColor = color
    }
}
