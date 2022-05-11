//
//  ImageLoader.swift
//  CountryListDemo
//
//  Created by Ivan Lugantsov on 04.05.2022.
//

import UIKit

public final class ImageLoader {
    
   // public static let shared = ImageLoader()
  //  private let cache: ImageCacheType
    
  //  public var indicatorType: Bool = false
    
    public var indicatorColor: UIColor = .black
    
//    public init(cache: ImageCacheType = ImageCache()) {
//        self.cache = cache
//    }

//    public func loadImage(from url: URL) -> AnyPublisher<UIImage?, Never> {
//        if let image = cache[url] {
//            return Just(image).eraseToAnyPublisher()
//        }
//        return URLSession.shared.dataTaskPublisher(for: url)
//            .map { (data, response) -> UIImage? in return UIImage(data: data) }
//            .catch { error in return Just(nil) }
//            .handleEvents(receiveOutput: { [unowned self] image in
//                guard let image = image else { return }
//                self.cache[url] = image
//            })
//            .print("Image loading \(url):")
//            .subscribe(on: backgroundQueue)
//            .receive(on: RunLoop.main)
//            .eraseToAnyPublisher()
//    }
//
//    func loadImage(urlStr: String, imageView: UIImageView) {
//        guard let url = URL(string: urlStr) else {
//            actyvivtyIndicator.stopAnimating()
//            return
//        }
//
//        var baseImage = UIImage(named: "plugImage")
//
//        if let image = cache[url] {
//            baseImage = image
//            actyvivtyIndicator.stopAnimating()
//        } else {
//            NetworkService.shared.fetchImage(urlStr: urlStr) { [weak self] data in
//                baseImage = UIImage(data: data)
//                self?.cache[url] = UIImage(data: data)
//                self?.actyvivtyIndicator.stopAnimating()
//            }
//        }
//        imageView.image = baseImage
//    }
    
//    private func setIndicator(imageView: UIImageView) {
//        imageView.addSubview(actyvivtyIndicator)
//
//        actyvivtyIndicator.snp.makeConstraints { make in
//            make.center.equalToSuperview()
//        }
//    }
}


public typealias KFCrossPlatformImageView = UIImageView

private var isActiveIndicatorKey = "isActiveIndicatorKey"
extension KFCrossPlatformImageView: KingfisherCompatible {}

public struct KingfisherWrapper<Base>: AssociatedStore {
    
    var actyvivtyIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.tintColor = .black
        indicator.style = .large
        return indicator
    }()
    
    private let cache = ImageCache()
    
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol KingfisherCompatible: AnyObject {}

extension KingfisherCompatible {
    /// Gets a namespace holder for Kingfisher compatible types.
    public var kf: KingfisherWrapper<Self> {
        get { return KingfisherWrapper(self) }
        set { }
    }
}

extension KingfisherWrapper where Base: KFCrossPlatformImageView {
    
    var isActiveIndicator: Bool {
        get {
            guard let value: Bool = associatedObject(forKey: &isActiveIndicatorKey) else {
                setAssociatedObject(false, forKey: &isActiveIndicatorKey)
                return false
            }
            if value {
                setIndicator()
            }
            return value
        }
        set {
            setAssociatedObject(newValue, forKey: &isActiveIndicatorKey)
        }
    }
    
    func loadImage(urlStr: String) {
        startIndecator(value: true)
        guard let url = URL(string: urlStr) else {
            base.image = UIImage(named: "plugImage")
            startIndecator(value: false)
            return
        }
                
        if let image = cache[url] {
            base.image = image
            startIndecator(value: false)
            return
        } else {
            NetworkService.shared.fetchImage(urlStr: urlStr) { [weak cache] data in
                base.image = UIImage(data: data)
                cache?[url] = UIImage(data: data)
                startIndecator(value: false)
                return
            }
        }
        
        base.image = UIImage(named: "plugImage")
    }
    
    private func startIndecator(value: Bool) {
       // guard isActiveIndicator == true else { return }
        if value {
            actyvivtyIndicator.startAnimating()
        } else {
            actyvivtyIndicator.stopAnimating()
        }
    }
    
    func setIndicator() {
        base.addSubview(actyvivtyIndicator)
        
        actyvivtyIndicator.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
    }
}
