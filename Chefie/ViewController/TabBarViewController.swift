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
        tabBar.items?[2].tag = 2
       
        
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
  
        self.tabBarController?.tabBar.frame.height ?? 49.0
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        print("Selected view controller")
    }
    
    var lastIndex = 0
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        
        print("")
        
        return false
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        if item.tag == 2 {
            
//            let lastItem = tabBar.items?.first
//          
//            self.selectedViewController = viewControllers![0]

           
            //self.tabBarController?.selectedIndex = 0
              //self.tabBarController?.selectedViewController = viewControllers![0]
            
        //    self.tabBar(tabBar, didSelect: lastItem!)
            let vc = UIStoryboard(name: "UploadRecipe", bundle: nil).instantiateViewController(withIdentifier: "UploadRecipeViewController")

            let navigationController = UINavigationController(rootViewController: vc)

            navigationItem.leftItemsSupplementBackButton = true
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "<", style: .plain, target: self, action: nil)

       //    tabBar.selectedItem = tabBar.items![lastIndex!] as UITabBarItem


            self.present(navigationController, animated: true, completion: nil)
        }
        if item.tag == 4 {
            
            let vc = UIStoryboard(name: "", bundle: nil).instantiateViewController(withIdentifier: "")
            
            let navigationController = UINavigationController(rootViewController: vc)
            
            navigationItem.leftItemsSupplementBackButton = true
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: nil)
            
            self.present(navigationController, animated: true, completion: nil)
        }
    }
}
