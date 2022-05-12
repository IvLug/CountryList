//
//  TabBarController.swift
//  CountryListDemo
//
//  Created by Ivan Lugantsov on 13.05.2022.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = .systemGray6
        configure()
    }
    
    private func configure() {
        
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowRadius = 3
        tabBar.layer.shadowOpacity = 0.3
    
        let regionList = RegionListAssembly.assembly().view
        let regionImage = UIImage(named: "region")?.resizeImage(targetSize: CGSize(width: 30, height: 30))
        regionList.tabBarItem.title = "Regions"
        regionList.tabBarItem.image =  regionImage
        
        let countryList = CountryListAssembly.assembly().view
        let countryImage = UIImage(named: "country")?.resizeImage(targetSize: CGSize(width: 30, height: 30))
        countryList.tabBarItem.title = "Countries"
        countryList.tabBarItem.image =  countryImage
        
        self.viewControllers = [regionList, countryList]
    }
}
