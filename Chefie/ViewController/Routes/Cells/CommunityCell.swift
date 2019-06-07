import Foundation
import UIKit
import SkeletonView
import SDWebImage
import AACarousel

class CommunityCellItemInfo : BaseItemInfo {
    
    override func reuseIdentifier() -> String {
        return "CommunityCell"
    }
}

class CommunityCell : BaseCell, ICellDataProtocol {

    typealias T = Community
    
    var model: Community?
    
    let frontImageView : UIImageView = {
        
        let img = UIImageView(maskConstraints: false)
        img.contentMode = ContentMode.scaleToFill
        return img
    }()
    
    let overlayView : UIView = {
        
        let view = UIView(maskConstraints: false)
        view.backgroundColor = UIColor().toRgba(r: 0, g: 0, b: 0, alpha: 0.5)
        return view
    }()
    
    let communityNameLabel : MultilineLabel = {
        let lbl = MultilineLabel(maskConstraints: false, font: DefaultFonts.DefaultHeaderTextFont)
        lbl.textColor = UIColor.white
        return lbl
    }()

    override func getSize() -> CGSize {
        return CGSize(width: parentView.getWidth(), height: parentView.heightPercentageOf(amount: 28))
    }
    
    override func setModel(model: AnyObject?) {
        self.model = (model as! Community)
    }
    
    override func getModel() -> AnyObject? {
        return model
    }
    
    override func onLayout(size: CGSize!) {
        super.onLayout(size: size)
        
        let cellSize = getSize()
        let sizeN = CGSize(width: cellSize.width.minus(amount: 5), height: cellSize.height.minus(amount: 5))
        
        self.contentView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
            maker.left.top.right.bottom.equalTo(0)
            maker.size.equalTo(cellSize)
        }
        
        self.frontImageView.snp.makeConstraints { (maker) in
            
            maker.size.equalTo(sizeN)
            maker.topMargin.equalTo(10)
            maker.bottomMargin.equalTo(10)
            maker.left.equalTo(sizeN.widthPercentageOf(amount: 2.5))
        }
        
        self.overlayView.snp.makeConstraints { (maker) in
            
            maker.topMargin.equalTo(10)
            maker.bottomMargin.equalTo(1)
            maker.size.equalTo(sizeN)
            maker.left.equalTo(sizeN.widthPercentageOf(amount: 2.5))
        }
        
     //   self.frontImageView.setCornerRadius()
       // self.overlayView.setCornerRadius()
        
        contentView.showAnimatedGradientSkeleton()
    }
    
    func restoreLayout() {
    
        self.frontImageView.snp.remakeConstraints({ (maker) in
            maker.size.equalTo(self.getSize())
            maker.left.equalTo(0)
        })
        
        self.overlayView.snp.remakeConstraints({ (maker) in
            maker.size.equalTo(self.getSize())
        })
        
        self.communityNameLabel.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
        }
        
        self.frontImageView.removeCornerRadius()
        self.overlayView.removeCornerRadius()
    }
    
    override func onLoadData() {
        super.onLoadData()
 
        self.frontImageView.sd_setImage(with: URL(string: model?.picture ?? "")){ (image : UIImage?,
                    error : Error?, cacheType : SDImageCacheType, url : URL?) in
            self.restoreLayout()
            self.hideSkeleton()
            
            self.communityNameLabel.text = self.model?.name
            
            self.doFadeIn()
        }
    }

    @objc func onTouch() {
        
    
    }
    
    override func onCreateViews() {
        super.onCreateViews()
        
        contentView.addSubview(frontImageView)
        contentView.addSubview(overlayView)
        contentView.addSubview(communityNameLabel)
    }
}
