import Foundation
import UIKit
import SnapKit
import SDWebImage

class UserSearchCellItemInfo : BaseItemInfo{
    
    override func reuseIdentifier() -> String {
        return "UserSearchCell"
    }
}

class UserSearchCell : BaseCell, ICellDataProtocol{
    
    typealias T = ChefieUser
    
    var model: ChefieUser?
    
    let userLabel : MultilineLabel = {
        let lbl = MultilineLabel(maskConstraints: false)
        lbl.text = ""
        lbl.numberOfLines = 1
        return lbl
    }()

    let userIcon : UIImageView = {
        let img = UIImageView(maskConstraints: false)
      //  img.contentMode = ContentMode.scaleAspectFit
        return img
    }()
    
    override func setModel(model: AnyObject?) {
        self.model = model as? ChefieUser
    }
    
    override func getSize() -> CGSize {
        return CGSize(width: parentView.getWidth(), height: parentView.heightPercentageOf(amount: 50))
    }

    override func onLayout(size: CGSize!) {
      super.onLayout(size: size)
        
       let cellSize = CGSize(width: parentView.getWidth(), height: size.heightPercentageOf(amount: 20))
        
        self.contentView.snp.makeConstraints { (maker) in
         
            maker.edges.equalToSuperview()
            //maker.left.top.right.equalToSuperview()
            maker.width.equalTo(cellSize.width)
            maker.height.equalTo(cellSize.height)
        }
        
        self.userIcon.frame = CGRect(x: 0, y: 0, width: cellSize.widthPercentageOf(amount: 32), height: cellSize.heightPercentageOf(amount: 80))
        
        self.userIcon.snp.makeConstraints { (maker) in
         //  maker.edges.equalToSuperview()
          // maker.center.equalTo(self.contentView)
            maker.left.equalTo(10)
            maker.centerY.equalToSuperview()
            
            maker.width.equalTo(cellSize.widthPercentageOf(amount: 32))
            maker.height.equalTo(cellSize.heightPercentageOf(amount: 80))
        }
        
        self.userLabel.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
        }
        
        self.userIcon.setCircularImageView()
        self.backgroundColor = .clear
    
        contentView.showAnimatedGradientSkeleton()
    }
    
    override func onLoadData() {
        super.onLoadData()
        userLabel.text = model?.userName
        
        self.userIcon.sd_setImage(with: URL(string: self.model?.profilePic ?? "")){ (image : UIImage?,
            error : Error?, cacheType : SDImageCacheType, url : URL?) in
            
            self.hideSkeleton()
        }
    }
    
    override func onCreateViews() {
        super.onCreateViews()
        self.contentView.addSubview(userLabel)
        self.contentView.addSubview(userIcon)
    }
}


