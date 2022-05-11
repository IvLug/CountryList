//
//  ViewController.swift
//  gruza
//
//  Created by Anastas Smekh on 25.07.2021.
//

import UIKit
import SnapKit

typealias NavigationVoid = () -> Void

class BaseViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    private var window: UIWindow?  = {
        return UIApplication.shared.delegate?.window ?? UIWindow()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}
