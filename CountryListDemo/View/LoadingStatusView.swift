//
//  LoadingStatusView.swift
//  CountryListDemo
//
//  Created by Ivan Lugantsov on 11.05.2022.
//

import UIKit

enum ErrorType {
    case wentWrongError
    case dataNotFound
    case notError
    case isLoading
}

class LoadingStatusView: UIView {
    
    private lazy var networkErrorView = NetworkErrorView()
    private lazy var activityIndicator = ActivityIndicator()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubviews()
        layoutSubview()
        networkErrorView.isHidden = true
        self.isHidden = true
    }
    
    private func addSubviews() {
        addSubview(networkErrorView)
        addSubview(activityIndicator)
    }
    
    private func layoutSubview() {
        networkErrorView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        activityIndicator.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.width.height.equalTo(40)
        }
    }
    
    func setLoadingStatus(type: ErrorType, view: UIView?) {
        switch type {
        case .wentWrongError:
            networkErrorView.setTitle("Sorry ;(")
            activityIndicator.isActiv = false
            stopLoading()
            hideStatusView(isHide: false, view: view)
        case .dataNotFound:
            networkErrorView.setTitle("Not found!")
            hideStatusView(isHide: false, view: view)
            stopLoading()
        case .notError:
            hideStatusView(isHide: true, view: view)
            stopLoading()
        case .isLoading:
            view?.isHidden = true
            self.isHidden = false
            networkErrorView.isHidden = true
            activityIndicator.isActiv = true
        }
    }
    
    func hideStatusView(isHide: Bool, view: UIView?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.isHidden = isHide
            self.networkErrorView.isHidden = isHide
            view?.isHidden = !isHide
            view?.isUserInteractionEnabled = isHide
        }
    }
    
    func stopLoading() {
        self.activityIndicator.isActiv = false
    }
}

