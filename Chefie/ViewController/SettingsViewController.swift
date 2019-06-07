//
//  SettingsViewController.swift
//  Chefie
//
//  Created by Edgar Doutón Parra on 23/05/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import GoogleSignIn
import SkeletonView
import SDWebImage

class SettingsViewController: UIViewController {

    var updates: [[String]] = [["Username", ""], ["Passsword", ""], ["Confirm password", ""], []]

    @IBOutlet weak var mainTable: UITableView!{
        didSet {
            mainTable.setCellsToAutomaticDimension()
        }
    }
    override func updateViewConstraints() {

        mainTable.snp.makeConstraints { (make) in

            make.width.equalTo(self.view)
            make.height.equalTo(self.view)
        }

        super.updateViewConstraints()
    }

    func onSetup() {
    
    }

    func onSetupViews(){

    }

    func onLoadData() {

    }

    func onLayout() {

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setTintColor()
        onSetup()
        onSetupViews()
    }
}



