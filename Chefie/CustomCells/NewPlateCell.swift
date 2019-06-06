import UIKit
import SDWebImage
import SnapKit

class NewPlateMediaCellItemInfo : BaseItemInfo {
    
    override func reuseIdentifier() -> String {
        return "NewPlateMediaCell"
    }
}
class NewPlateMediaCell : BaseCell, ICellDataProtocol {
    var model: Plate?
    
    typealias T = Plate
    
    let frontImageView : UIImageView = {
        
        let img = UIImageView(maskConstraints: false)
        img.contentMode = ContentMode.scaleToFill
        
        return img
    }()
    
    override func getSize() -> CGSize {
        return CGSize(width: parentView.getWidth(), height: parentView.heightPercentageOf(amount: 35))
    }
    
    override func onLayout(size: CGSize!) {
        super.onLayout(size: size)
        
        let cellSize = getSize()
        
        self.contentView.snp.makeConstraints { (maker) in
            maker.left.top.right.bottom.equalTo(0)
            maker.edges.equalToSuperview()
            maker.size.equalTo(cellSize)
        }
        
        self.frontImageView.snp.makeConstraints { (maker) in
          
             maker.size.equalTo(cellSize)
        }
        
        contentView.showAnimatedGradientSkeleton()
    }
    
    override func setModel(model: AnyObject?) {
        self.model = (model as! Plate)
    }
    
    override func getModel() -> AnyObject? {
        return model as AnyObject?
    }
    
    override func onLoadData() {
        super.onLoadData()
        
        self.frontImageView.setTouch(target: self, selector: #selector(onTouch))
        
        if let media = model?.multimedia {
            
            if !media.isEmpty{
                
                self.frontImageView.sd_setImage(with: URL(string: self.model?.multimedia?[0].url ?? "")){ (image : UIImage?,
                    error : Error?, cacheType : SDImageCacheType, url : URL?) in
                    
                    self.hideSkeleton()
                }
            }
        }
    }
    
    @objc func onTouch() {
        
        let storyboard = UIStoryboard(name: "PlateDetailStoryboard", bundle: nil)
        let vc  : PlateDetailsViewController = storyboard.instantiateViewController(withIdentifier: "PlateDetailViewController") as! PlateDetailsViewController
        
        vc.model = model
        
        self.viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func onCreateViews() {
        super.onCreateViews()
        
        self.contentView.addSubview(frontImageView)
    }
}
