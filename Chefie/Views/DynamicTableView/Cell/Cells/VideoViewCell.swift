////
////  VideoViewCell.swift
////  Chefie
////
////  Created by Nicolae Luchian on 05/05/2019.
////  Copyright © 2019 chefie. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//class VideoViewCell : UITableViewCell, ChefieCellViewProtocol {
//    
//    typealias T = Media
//    
//    var onAction: (() -> Void)?
//    
//    var parentView: UIView!{
//        
//        didSet{
//            
//            let size = CGSize(width: self.contentView.getWidth(), height: self.contentView.getHeight())
//            
//            onLayout(size: size)
//        }
//    }
//    
//    let videoView : MMPlayerView = {
//        
//        let view = MMPlayerView(frame: CGRect())
//        view.isSkeletonable = true
//        view.setCornerRadius()
//        return view
//    }()
//    
//    var model: Media?{
//        
//        didSet{
//            
//            onLoadData()
//        }
//    }
//    
//    func onLayout(size: CGSize!) {
//  
//        videoView.setCornerRadius()
//        videoView.snp.makeConstraints { (maker) in
//            maker.left.equalTo(10)
//            maker.top.equalTo(0)
//            maker.width.equalTo(size.width - 20)
//            maker.height.equalTo(size.height - 10)
//        }
//        
//        self.showAnimatedGradientSkeleton()
//    }
//    
//    func onCreateViews() {
//        
//        self.contentView.addSubview(videoView)
//    }
//    
//    func onLoadData() {
//        
//        let url = URL.init(string: model?.url ?? "")!
//    //
//       // videoView.replace(cover: CoverA.instantiateFromNib())
//        videoView.set(url: url, thumbImage: #imageLiteral(resourceName: "seven")) { (status) in
//         
//            switch status{
//                
//            case .ready:
//                
//                print("ready")
//                break
//            case .unknown:
//                break
//            case .failed(let err):
//                break
//            case .playing:
//                 break
//            case .pause:
//                 break
//            case .end:
//                 break
//            }
//        }
//
//        videoView.showLoading()
//    }
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        
//        onCreateViews()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//}
