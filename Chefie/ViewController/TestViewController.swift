//
//  TestViewController.swift
//  Chefie
//
//  Created by Steven on 22/04/2019.
//  Copyright © 2019 chefie. All rights reserved.
//
import SnapKit
import UIKit

class TestViewController: UIViewController {
    
    lazy var box = UILabel()
    
    @IBOutlet weak var btnTest: UIButton!
    lazy var boxTest = UIButton()
    
    @IBOutlet weak var lblTest: UILabel!
    @IBOutlet weak var mainScroll: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(boxTest)
        self.view.addSubview(box)
        
  
        btnTest.isSkeletonable = true
        lblTest.isSkeletonable = true
        
        self.view.showAnimatedGradientSkeleton()
      
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
