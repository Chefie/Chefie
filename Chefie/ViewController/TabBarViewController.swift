//
//  TabBarViewController.swift
//  Chefie_Register_Test
//
//  Created by Nicolae Luchian on 04/03/2019.
//  Copyright © 2019 Nicolae Luchian. All rights reserved.
//

import UIKit

var tabVC = UITabBarController()

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    var lastIndex = 0
    
    @IBInspectable var height: CGFloat = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = EventContainer.shared.TabBarVC.subscribe { (event) in
            
            self.selectedIndex = self.lastIndex
        }
        
        self.tabBar.backgroundColor = UIColor.white
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        
        //Ajustar cada elemento de los items del tab bar
        //print(self.tabBar.items?.count)
        tabBarItem = self.tabBar.items![0]
        tabBarItem.image = UIImage(named: "recipes1")?.withRenderingMode(.alwaysOriginal)
        tabBarItem.selectedImage = UIImage(named: "recipes2")?.withRenderingMode(.alwaysOriginal)
        tabBar.items?[0].title = "Recipes"
        tabBar.items?[0].tag = 0
        
        tabBarItem = self.tabBar.items![1]
        tabBarItem.image = UIImage(named: "search1")?.withRenderingMode(.alwaysOriginal)
        tabBarItem.selectedImage = UIImage(named: "search2")?.withRenderingMode(.alwaysOriginal)
        tabBar.items?[1].title = "Search"
        tabBar.items?[1].tag = 1
        
        tabBarItem = self.tabBar.items![2]
        tabBarItem.image = UIImage(named: "addFood")?.withRenderingMode(.alwaysOriginal)
        tabBarItem.selectedImage = UIImage(named: "addFood2")?.withRenderingMode(.alwaysOriginal)
        tabBar.items?[2].title = "Add recipe"
        tabBar.items?[2].tag = 2
        
        tabBarItem = self.tabBar.items![3]
        tabBarItem.image = UIImage(named: "finish1")?.withRenderingMode(.alwaysOriginal)
        tabBarItem.selectedImage = UIImage(named: "finish2")?.withRenderingMode(.alwaysOriginal)
        tabBar.items?[3].title = "Routes"
        tabBar.items?[3].tag = 3
        tabBarItem = self.tabBar.items![4]
        tabBarItem.image = UIImage(named: "chef1")?.withRenderingMode(.alwaysOriginal)
        tabBarItem.selectedImage = UIImage(named: "chef2")?.withRenderingMode(.alwaysOriginal)
        tabBar.items?[4].title = "Profile"
        tabBar.items?[4].tag = 4
        tabBar.tintColor = UIColor.white
   
        tabBar.items?.forEach({ (item) in
            item.imageInsets = UIEdgeInsets.init(top: 8, left: 0, bottom: -8, right: 0)
            item.title = ""
        })
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    
        if (item.tag != 2){
              self.lastIndex = item.tag
        }
        if item.tag == 2 {
            
            let vc = UIStoryboard(name: "UploadRecipe", bundle: nil).instantiateViewController(withIdentifier: "UploadRecipeViewController")
            
            let navigationController = UINavigationController(rootViewController: vc)

            self.present(navigationController, animated: true, completion: nil)
        }
        else if item.tag == 4 {
            EventContainer.shared.ProfileSubject.on(.next(""))
        }
    }
}
