//
//  ActyvityIndicator.swift
//  CountryListDemo
//
//  Created by Ivan Lugantsov on 11.05.2022.
//

import UIKit

class ActivityIndicator: UIView {
    
    private let circle = CALayer()
    
    public var speed = 9
    public var numberOfCircles = 12
    
    public var isActiv: Bool = false {
        didSet {
            guard isActiv == true else {
                removeAnimation()
                return
            }
            drawDesign()
        }
    }
    
    var animate: Bool = false
    
    public var circleSize: Int = 15
    public var circleColor: CGColor = UIColor.systemBlue.cgColor
    
    override class var layerClass: AnyClass {
        get {
            return CAReplicatorLayer.self
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setCiscle(size: circleSize)
        circle.backgroundColor = circleColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func scale(_ speed: Int) -> Double {
        guard speed <= 10 else { return 10 }
        guard Double(speed) >= 0.5 else { return 0.5 }
        
        let input_start = 1.0
        let input_end = 10.0
        let output_start = 3.0
        let output_end = 0.5
        return (Double(speed) - input_start) / (input_end - input_start) * (output_end - output_start) + output_start
    }
    
    private func setCiscle(size: Int) {
        circle.frame = CGRect(
            origin: CGPoint.zero,
            size: CGSize(width: size, height: size))
        
        circle.cornerRadius = CGFloat(size / 2)
        circle.position = self.center
        circle.opacity = 0
    }
    
    private func drawDesign() {
        guard !animate else { return }
        animate = true
        self.circle.removeAllAnimations()
        self.circle.sublayers = nil
        
        guard let replicatorLayer = layer as? CAReplicatorLayer else { return }
        replicatorLayer.addSublayer(circle)
        
        let duration = scale(speed)
        let instanceCount = numberOfCircles
        replicatorLayer.instanceCount = instanceCount
        replicatorLayer.instanceDelay = duration / CFTimeInterval(instanceCount)
        
        let angle = CGFloat.pi * 2 / CGFloat(instanceCount)
        replicatorLayer.instanceTransform = CATransform3DMakeRotation(angle, 0, 0, 1)
        
        let fadeOut = CABasicAnimation(keyPath: "opacity")
        fadeOut.fromValue = 1
        fadeOut.toValue = 0
        fadeOut.duration = scale(speed)
        fadeOut.repeatCount = Float.greatestFiniteMagnitude
        circle.add(fadeOut, forKey: nil)
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.toValue = 4 / numberOfCircles
        scaleAnimation.duration = 0.5
        scaleAnimation.repeatCount = .infinity
        scaleAnimation.duration = scale(speed)
        circle.add(scaleAnimation, forKey: "scaleAnimation")
    }
    
    private func removeAnimation() {
        guard animate else { return }
        UIView.animate(withDuration: 0.3) {
            self.alpha = 0
        } completion: { _ in
            self.circle.removeAllAnimations()
            self.circle.sublayers = nil
            self.alpha = 1
            self.animate = false
        }
    }
}
