
import Foundation
import UIKit
import Kingfisher
import SkeletonView
import SDWebImage

class PlatoCellItemInfo : BaseItemInfo {

    override func identifier() -> String {
        return "PlatoCellView"
    }
}

class PlatoCellView : BaseCell, ICellDataProtocol {

    typealias T = Plate
    
    var model: Plate?{
        
        didSet{
            
            print("Model")
        }
    }
    
    override func getModel() -> AnyObject? {
        return model
    }

    override func setModel(model: AnyObject?) {
        self.model = model as? Plate
    }
    
    let frontImageView : UIImageView = {
        
        let img = UIImageView()
        img.contentMode = ContentMode.scaleToFill
        img.isSkeletonable = true
        img.setRounded()
        return img
    }()
    
    let label : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .center
        lbl.textColor = .black
        lbl.text = ""
        lbl.isSkeletonable = true
        lbl.frame = CGRect(x: 10, y: 10, width: 100, height: 10)
        lbl.linesCornerRadius = 10
        return lbl
    }()
    
    override func getSize() -> CGSize {
        
        return CGSize(width: self.parentView.frame.width, height: self.parentView.heightPercentageOf(amount: 20))
    }
    
    override func onLayout(size : CGSize!) {
        
        let cellSize = CGSize(width: size.width, height: size.heightPercentageOf(amount: 30))
        
        let imageHeight = cellSize.height.percentageOf(amount: 91)
        let titleFontHeight = max(label.font.lineHeight, cellSize.height.percentageOf(amount: 9))
        
        label.setCornerRadius()
        label.snp.makeConstraints { (maker) in
            
            maker.left.equalTo(cellSize.widthPercentageOf(amount: 2))
            maker.top.equalTo(cellSize.height.percentageOf(amount: 2))
            maker.width.equalTo(cellSize.width.minus(amount: 4))
            maker.height.equalTo(titleFontHeight)
        }
        
        frontImageView.setCornerRadius()
        frontImageView.addShadow()
        frontImageView.snp.makeConstraints { (maker) in
            
            maker.left.equalTo(cellSize.widthPercentageOf(amount: 2))
            maker.top.equalTo(titleFontHeight + 6)
            maker.width.equalTo(cellSize.width.minus(amount: 4))
            maker.height.equalTo(imageHeight)
            maker.bottomMargin.equalToSuperview()
        }
        
        // frontImageView.roundedImage()
        // self.contentView.backgroundColor = UIColor.red
        
        self.showAnimatedGradientSkeleton()
    }
    
    override func onLoadData() {
        
        doFadeIn()
        self.frontImageView.sd_setImage(with: URL(string: model?.multimedia?[0].url ?? "")){ (image : UIImage?,
            error : Error?, cacheType : SDImageCacheType, url : URL?) in
            
            self.label.text = self.model?.title
            
            self.hideSkeleton()
        }
    }
    
    override func onCreateViews() {
        
        self.contentView.addSubview(label)
        self.contentView.addSubview(frontImageView)
        frontImageView.setTouch(target: self, selector: #selector(onTouch))
    }
    
    @objc func onTouch() {
        
        let storyboard = UIStoryboard(name: "PlateDetailStoryboard", bundle: nil)
        let vc  : PlateDetailsViewController = storyboard.instantiateViewController(withIdentifier: "PlateDetailViewController") as! PlateDetailsViewController

        vc.model = model
        
        self.viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func identifier() -> String {
        return "PlatoCellView"
    }
}
