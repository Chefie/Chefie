//
//  TabBarViewController.swift
//  Chefie_Register_Test
//
//  Created by Nicolae Luchian on 04/03/2019.
//  Copyright © 2019 Nicolae Luchian. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    @IBInspectable var height: CGFloat = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        

        
        //Ajustar cada elemento de los items del tab bar
        //print(self.tabBar.items?.count)
        
        tabBarItem = self.tabBar.items![0]
        tabBarItem.image = UIImage(named: "dishes1")?.withRenderingMode(.alwaysOriginal)
        tabBarItem.selectedImage = UIImage(named: "dishes2")?.withRenderingMode(.alwaysOriginal)
        tabBar.items?[0].title = "Recipes"
      
        
        
        tabBarItem = self.tabBar.items![1]
        tabBarItem.image = UIImage(named: "search1")?.withRenderingMode(.alwaysOriginal)
        tabBarItem.selectedImage = UIImage(named: "search2")?.withRenderingMode(.alwaysOriginal)
        tabBar.items?[1].title = "Search"
        
        tabBarItem = self.tabBar.items![2]
        tabBarItem.image = UIImage(named: "addFood")?.withRenderingMode(.alwaysOriginal)
        tabBarItem.selectedImage = UIImage(named: "addFood")?.withRenderingMode(.alwaysOriginal)
        tabBar.items?[2].title = "Add recipe"
        
        tabBarItem = self.tabBar.items![3]
        tabBarItem.image = UIImage(named: "route1")?.withRenderingMode(.alwaysOriginal)
        tabBarItem.selectedImage = UIImage(named: "route2")?.withRenderingMode(.alwaysOriginal)
        tabBar.items?[3].title = "Routes"
        
        tabBarItem = self.tabBar.items![4]
        tabBarItem.image = UIImage(named: "profile1")?.withRenderingMode(.alwaysOriginal)
        tabBarItem.selectedImage = UIImage(named: "profile2")?.withRenderingMode(.alwaysOriginal)
        tabBar.items?[3].title = "Profile"
        
    }
}
