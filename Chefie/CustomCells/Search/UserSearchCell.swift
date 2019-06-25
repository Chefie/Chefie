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
        img.contentMode = ContentMode.scaleToFill
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
            maker.left.top.right.bottom.equalTo(0)
            maker.width.equalTo(cellSize.width)
            maker.height.equalTo(cellSize.height)
        }
        
        let userIconFrame = CGRect(x: 0, y: 0, width: cellSize.widthPercentageOf(amount: 24), height: cellSize.heightPercentageOf(amount: 80))
        
        
        self.userIcon.frame = userIconFrame
        self.userIcon.snp.makeConstraints { (maker) in

         //  maker.edges.equalToSuperview()
            maker.leftMargin.equalTo(10)
            maker.centerY.equalToSuperview()
            maker.width.equalTo(userIconFrame.width)
            
             maker.height.equalTo(userIconFrame.height)
        }
        
        self.userLabel.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
            maker.width.equalTo(cellSize.widthPercentageOf(amount: 70))
        }
        
        self.userIcon.setCircularImageView()
       
        self.userLabel.displayLines(height: 50)
        self.userIcon.showAnimatedGradientSkeleton()
    }
    
    override func onLoadData() {
        super.onLoadData()

        self.userIcon.sd_setImage(with: URL(string: self.model?.profilePic ?? "")){ (image : UIImage?,
            error : Error?, cacheType : SDImageCacheType, url : URL?) in
            
            self.userLabel.hideLines()
            self.userIcon.hideSkeleton()
           
            self.userLabel.text = self.model?.userName
            
            
            self.reloadCell()
        }
    }
    
    @objc func onTouch() {

        let storyboard = UIStoryboard(name: "ForeignProfileStoryboard", bundle: nil)
        let vc  : ForeignProfileViewController = storyboard.instantiateViewController(withIdentifier: "ForeignProfileViewController") as! ForeignProfileViewController
        
        vc.model = model?.mapToUserMin()
        self.viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func onCreateViews() {
        super.onCreateViews()
        self.contentView.addSubview(userLabel)
        self.contentView.addSubview(userIcon)
        
        self.contentView.setTouch(target: self, selector: #selector(onTouch))
    }
}


