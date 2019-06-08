//
//  ProfileFollowBtnCellView.swift
//  Chefie
//
//  Created by Alex Lin on 03/06/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import UIKit
import SkeletonView
import SDWebImage

class ProfileFollowBtnItemInfo : BaseItemInfo {
    override func reuseIdentifier() -> String {
        return "ProfileFollowBtnCellView"
    }
}

class ProfileFollowBtnCellView : BaseCell, ICellDataProtocol {
    
    var model: UserMin?
    
    typealias T = UserMin
    
    override func getModel() -> AnyObject? {
        return model
    }
    
    override func setModel(model: AnyObject?) {
        self.model = model as? UserMin
    }
    
    let labelUsername : UILabel = {
        let lbl = UILabel(maskConstraints: false, font: DefaultFonts.DefaultHeaderTextFont)
        lbl.text = "SOY UN BUTTON!"
        lbl.textAlignment = .center
        lbl.textColor = .white
        lbl.backgroundColor = .blue
        lbl.isSkeletonable = true
        lbl.adjustsFontForContentSizeCategory = true
        lbl.linesCornerRadius = 10
        return lbl
    }()
    
    var followBtn : UIButton = {
        var button = UIButton()
        button.contentMode = ContentMode.scaleToFill
        let image = UIImage(named: "followBtn") as UIImage?
        button.setImage(image, for: .normal)
        return button
    }()
    
    
    
    
    
    let buttonUpload: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "addButton") as UIImage?
        //button.backgroundColor = UIColor.green
        button.contentMode = ContentMode.scaleToFill
        button.setTitle("Upload recipe", for: .normal)
        button.setImage(image, for: .normal)
        //button.setTouch(target: self, selector: #selector(buttonAction))
        return button
        
    }()
    
    override func onLayout(size: CGSize!) {
        
        let cellSize = CGSize(width: size.width, height: size.heightPercentageOf(amount: 5))

        
        followBtn.snp.makeConstraints { (maker) in
            
            maker.height.equalTo(cellSize.height.minus(amount: 37))
            maker.width.equalTo(cellSize.width.minus(amount: 93))
            maker.leftMargin.equalTo(size.widthPercentageOf(amount: 45))
            maker.topMargin.equalTo(5)
            maker.bottom.equalTo(-5)
        }
        
        self.contentView.snp.makeConstraints { (maker) in
            maker.size.equalTo(cellSize)
        }
        
        self.showAnimatedGradientSkeleton()
        
        
    }
    
    override func onLoadData() {
        doFadeIn()
        appContainer.userRepository.checkIfFollowing(idUser: "2WT9s7km17QdtIwpYlEZ", idFollower: "uBkEMUpQjCUWMnbj3sQSmQLdG9q2") {
            (result:(ChefieResult<Bool>)) in
            switch result {
            case .success(let data):
                self.changeState(isFollowing: data)
                break
            case .failure(_):
                break
                
            }
            
        }
        
        self.hideSkeleton()
        
    }
    
    func changeState(isFollowing : Bool) {
        
        if(isFollowing){
            let image = UIImage(named: "unfollowBtn") as UIImage?
            self.followBtn.setImage(image, for: .normal)
        } else {
            let image = UIImage(named: "followBtn") as UIImage?
            self.followBtn.setImage(image, for: .normal)
        }
    }
    
    
    override func onCreateViews() {
        self.contentView.addSubview(followBtn)
        self.followBtn.setTouch(target: self, selector: #selector(followBtnTapped))
    }
    
    @objc func followBtnTapped() {
        appContainer.userRepository.checkIfFollowing(idUser: "2WT9s7km17QdtIwpYlEZ", idFollower: "uBkEMUpQjCUWMnbj3sQSmQLdG9q2") {
            (result:(ChefieResult<Bool>)) in
            switch result{
            case .success(let data):
                if data {
                    self.unfollowAction()
                    self.rmvFollowing()
                } else {
                    self.followAction()
                    self.addFollowing()
                }
                break
            case .failure(_):
                break
                
            }
        }
        
    }
    
    func followAction() {
        let image = UIImage(named: "unfollowBtn") as UIImage?
        self.followBtn.setImage(image, for: .normal)
        appContainer.userRepository.addFollower(idUser: "2WT9s7km17QdtIwpYlEZ", idFollower: "uBkEMUpQjCUWMnbj3sQSmQLdG9q2") {
            (result:(ChefieResult<Bool>)) in
            switch result{
            case .success(let data):
                if data {
                    print("Se ha añadido follower")
                }
                break
            case .failure(_):
                break
            }
            
        }
        
    }
    
    func unfollowAction(){
        let image = UIImage(named: "followBtn") as UIImage?
        self.followBtn.setImage(image, for: .normal)
        appContainer.userRepository.removeFollower(idUser: "2WT9s7km17QdtIwpYlEZ", idFollower: "uBkEMUpQjCUWMnbj3sQSmQLdG9q2") {
            (result: (ChefieResult<Bool>)) in
            switch result{
            case .success(let data):
                if data {
                    print("Se ha borrado follower")
                }
                break
            case .failure(_):
                break
                
            }
            
        }
        
    }
    
    func addFollowing(){
        appContainer.userRepository.addFollowerFollowing(idUser: "2WT9s7km17QdtIwpYlEZ", idFollowing: "uBkEMUpQjCUWMnbj3sQSmQLdG9q2") {
            (result: (ChefieResult<Bool>)) in
            switch result{
            case .success(let data):
                if data {
                    print("Se ha añadido following")
                }
                break
            case .failure(_):
                break
                
            }
            
        }
    }
    
    func rmvFollowing(){
        appContainer.userRepository.removeFollowerFollowing(idUser: "2WT9s7km17QdtIwpYlEZ", idFollowing: "uBkEMUpQjCUWMnbj3sQSmQLdG9q2") {
            (result: (ChefieResult<Bool>)) in
            switch result{
            case .success(let data):
                if data {
                    print("Se ha borrado following")
                }
                break
            case .failure(_):
                break
                
            }
            
        }
    }
    
}
