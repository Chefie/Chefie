
import Foundation
import UIKit
import Kingfisher
import SkeletonView
import SDWebImage

class PlatoCellItemInfo : BaseItemInfo {

    override func reuseIdentifier() -> String {
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
        
        let img = UIImageView(maskConstraints: false)
        img.contentMode = ContentMode.scaleToFill
        img.isSkeletonable = true
        img.setRounded()
        return img
    }()
    
    let label : MultilineLabel = {
        let lbl = MultilineLabel(maskConstraints: false)
        lbl.text = ""
        return lbl
    }()
    
    override func getSize() -> CGSize {
        
        return CGSize(width: self.parentView.frame.width, height: self.parentView.heightPercentageOf(amount: 20))
    }
    
    override func onLayout(size : CGSize!) {
        
        var cellSize = CGSize(width: size.width, height: size.heightPercentageOf(amount: 30))
        
        let imageHeight = cellSize.height.percentageOf(amount: 91)
        let titleFontHeight = max(label.font.lineHeight, cellSize.height.percentageOf(amount: 9))
    
     //   label.displayLines(height: titleFontHeight)
        
        frontImageView.setCornerRadius()
        frontImageView.addShadow()
        frontImageView.snp.makeConstraints { (maker) in
            
            maker.left.equalTo(cellSize.widthPercentageOf(amount: 2))
            maker.top.equalTo(titleFontHeight + 6)
            maker.width.equalTo(cellSize.width.minus(amount: 4))
            maker.height.equalTo(imageHeight)
            maker.bottomMargin.equalToSuperview()
        }
        
        self.contentView.snp.makeConstraints { (maker) in
            
            cellSize.height += 10
            maker.size.equalTo(cellSize)
        }
    //    frontImageView.setCircularImageView()
        
   //     self.contentView.fitHeightToSubViews()
        
        // frontImageView.roundedImage()
    
        
        self.showAnimatedGradientSkeleton()
    }
    
    override func onLoadData() {
            self.contentView.backgroundColor = UIColor.red
        doFadeIn()
        self.frontImageView.sd_setImage(with: URL(string: model?.multimedia?[0].url ?? "")){ (image : UIImage?,
            error : Error?, cacheType : SDImageCacheType, url : URL?) in
            
           // self.label.hideLines()
         //   self.label.text = self.model?.title
            self.hideSkeleton()
        }
    }
    
    override func onCreateViews() {
        
      //  self.contentView.addSubview(label)
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
