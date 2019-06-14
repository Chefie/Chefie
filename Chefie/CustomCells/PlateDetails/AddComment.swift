//
//  AddComment.swift
//  Chefie
//
//  Created by user155921 on 6/9/19.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import UIKit
import SCLAlertView

class AddCommentItemInfo : BaseItemInfo {
    override func reuseIdentifier() -> String {
        return "AddCommentCell"
    }
    
    var onCommentSent: (() -> Void)?
}

class AddCommentCell : BaseCell, ICellDataProtocol{
    
    typealias T = Plate
    var model: Plate?
    
    let addCommentLabel : MultilineLabel = {
        let lbl = MultilineLabel(maskConstraints: false, font: DefaultFonts.DefaultHeaderTextBoldFont)
        lbl.text = "Add Comment".localizedCapitalized
        lbl.numberOfLines = 1
        return lbl
    }()
    
    override func setModel(model: AnyObject?) {
        self.model = (model as? Plate)
    }
    
    override func getModel() -> AnyObject? {
        return model
    }
    
    override func getSize() -> CGSize {
        return CGSize(width: parentView.getWidth(), height: parentView.heightPercentageOf(amount: 5))
    }
    
    override func setBaseItemInfo(info: BaseItemInfo) {
        super.setBaseItemInfo(info: info)
    }
    
    override func onLayout(size: CGSize!) {
        super.onLayout(size: size)
        
        self.cellSize = getSize()
        
        self.contentView.snp.makeConstraints { (maker) in
            maker.left.top.right.bottom.equalTo(0)
            maker.size.equalTo(cellSize!)
        }
        
        self.addCommentLabel.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
            maker.width.equalToSuperview()
        }
    }
    
    override func onLoadData() {
        super.onLoadData()
    }
    
    @objc func onAddComment() {
        
        let appearance = SCLAlertView.SCLAppearance(
            kCircleIconHeight: 42.0, showCloseButton: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        let view = UINib(nibName: "CommentDialog", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView as! CommentDialogView
        view.setup(view: alertView.view)
        alertView.customSubview = view
        
        var cancelled = false
        
        alertView.addButton("Send") {
            
            if (!cancelled){
                let comment = Comment()
                comment.content = view.contentText.text
                comment.userMin = appContainer.getUser().mapToUserMin()
                comment.idUser = appContainer.getUser().id!
                
                appContainer.commentRepository.addComment(idRecipe: self.model!.id!, comment: comment) { (result : ChefieResult<Bool>) in
                    
                    let info = self.baseItemInfo as! AddCommentItemInfo
                    info.onCommentSent!()
                    
                    let user = appContainer.getUser()
             
                    if (user.id! != self.model!.idUser){
                        NotificationManager.shared.sendPostCommentNotification(sender: user.mapToUserMin(), targetUser: self.model!.user!, title: self.model!.title!, comment: comment)
                    }
                }
            }
        }
        
        alertView.addButton("Cancel") {
            
            cancelled = true
            alertView.dismiss(animated: true, completion: {
                
            })
        }
        alertView.showTitle("Post a Comment", subTitle: "", style: .edit)
    }
    
    override func onCreateViews() {
        super.onCreateViews()
        
        self.addCommentLabel.setTouch(target: self, selector: #selector(onAddComment))
        
        self.contentView.addSubview(addCommentLabel)
    }
}
