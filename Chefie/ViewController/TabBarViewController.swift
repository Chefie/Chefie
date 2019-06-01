//
//  TabBarViewController.swift
//  Chefie_Register_Test
//
//  Created by Nicolae Luchian on 04/03/2019.
//  Copyright © 2019 Nicolae Luchian. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    @IBInspectable var height: CGFloat = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        
        //Ajustar cada elemento de los items del tab bar
        //print(self.tabBar.items?.count)
        tabBarItem = self.tabBar.items![0]
        tabBarItem.image = UIImage(named: "recipes1")?.withRenderingMode(.alwaysOriginal)
        tabBarItem.selectedImage = UIImage(named: "recipes2")?.withRenderingMode(.alwaysOriginal)
        tabBar.items?[0].title = "Recipes"
      
        
        
        tabBarItem = self.tabBar.items![1]
        tabBarItem.image = UIImage(named: "search1")?.withRenderingMode(.alwaysOriginal)
        tabBarItem.selectedImage = UIImage(named: "search2")?.withRenderingMode(.alwaysOriginal)
        tabBar.items?[1].title = "Search"
        
        tabBarItem = self.tabBar.items![2]
        tabBarItem.image = UIImage(named: "addFood")?.withRenderingMode(.alwaysOriginal)
        tabBarItem.selectedImage = UIImage(named: "addFood2")?.withRenderingMode(.alwaysOriginal)
        tabBar.items?[2].title = "Add recipe"
        
        tabBarItem = self.tabBar.items![3]
        tabBarItem.image = UIImage(named: "finish1")?.withRenderingMode(.alwaysOriginal)
        tabBarItem.selectedImage = UIImage(named: "finish2")?.withRenderingMode(.alwaysOriginal)
        tabBar.items?[3].title = "Routes"
        
        tabBarItem = self.tabBar.items![4]
        tabBarItem.image = UIImage(named: "chef1")?.withRenderingMode(.alwaysOriginal)
        tabBarItem.selectedImage = UIImage(named: "chef2")?.withRenderingMode(.alwaysOriginal)
        tabBar.items?[3].title = "Profile"
        
        tabBar.tintColor = UIColor.white
        //tabBar.barTintColor = UIColor.black
        //tabBar.unselectedItemTintColor = UIColor.yellow
        
        tabBar.items?.forEach({ (item) in
            item.imageInsets = UIEdgeInsets.init(top: 8, left: 0, bottom: -8, right: 0)
            item.title = ""
        })
  
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
     
            print("Selected view controller")
    }
    
   
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
      tabBarController?.selectedIndex = 0
//        let storyBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let exampleVC = storyBoard.instantiateViewController(withIdentifier: "mainScreen" )
//        self.present(exampleVC, animated: true)
//
    
      print("Selected view controller")
    }
}
