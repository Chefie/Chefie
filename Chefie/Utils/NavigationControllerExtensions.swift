//
//  NavigationControllerExtensions.swift
//  Chefie
//
//  Created by Nicolae Luchian on 04/06/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func setDefaultBackButton(){
        
        self.navigationItem.leftItemsSupplementBackButton = false
        
        let leftButtonBack = UIBarButtonItem(image: UIImage(named: "back")!, style: .plain, target: self, action: #selector(onLeftBackTouch))
        self.navigationItem.leftBarButtonItem = leftButtonBack
    }
    
    @objc func onLeftBackTouch() {
        
        self.navigationController?.popViewController(animated: true)
        
    }
}
extension UINavigationController {
    
    func setTintColor(color : UIColor = UIColor.lightGray){
        // navigationItem.leftItemsSupplementBackButton = true
        self.navigationBar.tintColor = Palette.TextDefaultColor
    }
    
    @objc func onGoBack(completionHandler: @escaping () -> Void) {
        
        completionHandler()
    }
    
    func setTitle(title : String = "") {
        navigationItem.title = title
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: DefaultFonts.ZapFino]
    }
    
    func setBackButton(title : String = "") {
        //    navigationItem.leftItemsSupplementBackButton = true
        
        let backButton = UIBarButtonItem()
        backButton.title = title
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
}
