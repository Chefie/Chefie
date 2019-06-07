import Foundation
import UIKit
import SkeletonView
import SDWebImage
import FSPagerView

class PlatoCellItemInfo : BaseItemInfo {
    
    override func reuseIdentifier() -> String {
        return "PlatoCellView"
    }
}

class PlatoCellView : BaseCell, ICellDataProtocol, INestedCell {
    var collectionItemSize: CGSize!

    typealias T = Plate
    
    var model: Plate?
   
    let frontImageView : UIImageView = {
        
        let img = UIImageView(maskConstraints: false)
        img.contentMode = ContentMode.scaleToFill
        return img
    }()
    
    let pagerImageView : FSPagerView = {
        
        let view = FSPagerView(maskConstraints: false)
        return view
    }()
    
    let plateTitle : MultilineLabel = {
        let lbl = MultilineLabel(maskConstraints: false, font: DefaultFonts.DefaultTextFont)
        lbl.text = "AAAAAAAAAAA"
        lbl.numberOfLines = 1
        return lbl
    }()
    
    override func setModel(model: AnyObject?) {
        self.model = (model as! Plate)
    }
    
    override func getModel() -> AnyObject? {
        return model
    }
    
    override func onLayout(size: CGSize!) {
        super.onLayout(size: size)
        
        if let size = self.cellSize {
            
            collectionItemSize = size
        }
        
        self.contentView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
            maker.left.top.right.bottom.equalTo(0)
            maker.width.equalTo(size.width)
            maker.height.equalTo(collectionItemSize.height)
        }

        pagerImageView.snp.makeConstraints { (maker) in
            
            maker.width.equalTo(collectionItemSize.width.minus(amount: 10))
            maker.height.equalTo(collectionItemSize.heightPercentageOf(amount: 88))
            maker.topMargin.equalTo(0)
            maker.bottomMargin.equalTo(10)
            maker.left.equalTo(collectionItemSize.widthPercentageOf(amount: 5))
            //      maker.centerX.equalTo(contentView)
        }
  
        self.plateTitle.snp.makeConstraints { (maker) in
            
            maker.width.equalTo(collectionItemSize.width.minus(amount: 20))
            maker.height.equalTo(collectionItemSize.heightPercentageOf(amount: 10))
            maker.bottomMargin.equalToSuperview().offset(4)
            maker.centerX.equalToSuperview()
        }
        
        plateTitle.displayLines(height: collectionItemSize.heightPercentageOf(amount: 10))
        
        contentView.showAnimatedGradientSkeleton()
    }
    
    override func onLoadData() {

    }
    
    @objc func onTouch() {
        
        let storyboard = UIStoryboard(name: "PlateDetailStoryboard", bundle: nil)
        let vc  : PlateDetailsViewController = storyboard.instantiateViewController(withIdentifier: "PlateDetailViewController") as! PlateDetailsViewController
        
        vc.model = model
        
        self.viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func onCreateViews() {
        super.onCreateViews()
        
        collectionItemSize = CGSize(width: 0, height: 0)
        self.contentView.addSubview(pagerImageView)
        self.contentView.addSubview(plateTitle)
    }
}
