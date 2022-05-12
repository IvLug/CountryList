//
//  ViewController.swift
//  gruza
//
//  Created by Anastas Smekh on 25.07.2021.
//

import UIKit
import SnapKit

typealias NavigationVoid = () -> Void

class BaseViewController: UIViewController {
    
    private var window: UIWindow?  = {
        return UIApplication.shared.delegate?.window ?? UIWindow()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavBar()
    }
    
    func setupNavBar() {
        let navBarApirance = UINavigationBarAppearance()
        navBarApirance.configureWithOpaqueBackground()
        navBarApirance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarApirance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarApirance.backgroundColor = UIColor(red: 0.3165891171, green: 0.5658303499, blue: 0.934579432, alpha: 0.77)

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.standardAppearance = navBarApirance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarApirance
        navigationController?.navigationBar.tintColor = .white
        navigationItem.backButtonTitle = "Back"
    }
    
    func isHideTabBar(_ isHide: Bool) {
        tabBarController?.tabBar.isHidden = isHide
    }
}
