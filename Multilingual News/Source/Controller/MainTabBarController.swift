//
//  MainTabBarController.swift
//  Multilingual News
//
//  Created by Ted on 2021/04/29.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewControllers()
    }
    
    // MARK: - ConfigureVC
 
    private func configureViewControllers() {
        tabBar.tintColor = .oceanBlue
        tabBar.barTintColor = .white
        
        let main = MainViewController()
        let nav1 = templateNavigationController(image: UIImage(named: "home_unselected"), rootViewControoler: main)
        
        let donate = DonateViewController()
        let nav2 = templateNavigationController(image: UIImage(named: "like_unselected"), rootViewControoler: donate)
        
        viewControllers = [nav1, nav2]
    }
    
    private func templateNavigationController(image: UIImage?, rootViewControoler: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewControoler)
        nav.tabBarItem.image = image
        nav.navigationBar.barTintColor = .white
        return nav
    }
}
