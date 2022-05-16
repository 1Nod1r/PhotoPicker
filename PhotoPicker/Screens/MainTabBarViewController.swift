//
//  MainTabBarViewController.swift
//  PhotoPicker
//
//  Created by Nodirbek on 02/05/22.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let vc1 = createHomeVC()
        let vc2 = createLikesVC()
        
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "star")
        
        vc1.title = "Home"
        vc2.title = "Liked"
        
        tabBar.tintColor = .label
        
        setViewControllers([vc1,vc2], animated: true)
    }
    
    func createLikesVC() -> UINavigationController {
        let viewModel = LikeViewModel()
        let homeVC = LikesViewController(viewModel: viewModel)
        let navVc = UINavigationController(rootViewController: homeVC)
        return navVc
    }
    
    func createHomeVC() -> UINavigationController {
        let viewModel = HomeViewModel()
        let homeVC = HomeViewController(viewModel: viewModel)
        let navVc = UINavigationController(rootViewController: homeVC)
        return navVc
    }

    

}
