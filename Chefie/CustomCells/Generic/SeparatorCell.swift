import Foundation
import UIKit
import SnapKit
import SDWebImage

class SeparatorCellItemInfo : BaseItemInfo{
    
    override func reuseIdentifier() -> String {
        return "SeparatorCell"
    }
    
    var separatorPercentage : CGFloat = 3
    
    init(separatorPercentage : CGFloat = 3) {
        super.init()
        self.separatorPercentage = separatorPercentage
    }
}

class SeparatorCell : BaseCell, ICellDataProtocol{
    
    typealias T = Never
    
    var model: Never?
    
    var amount : CGFloat = 3

    override func onLayout(size: CGSize!) {
        super.onLayout(size: size)
      
        self.contentView.snp.makeConstraints { (maker) in
            maker.left.top.right.bottom.equalTo(0)
            maker.width.equalTo(size.width)
            maker.height.equalTo(size.heightPercentageOf(amount: amount))
        }
        
       // self.contentView.backgroundColor = UIColor.red
    }
    
    override func onLoadData() {
        super.onLoadData()
    }
    
    override func setBaseItemInfo(info: BaseItemInfo) {
        super.setBaseItemInfo(info: info)
        
        guard let itemInfo = info as? SeparatorCellItemInfo else {
            return
        }
        
        self.contentView.snp.updateConstraints { (maker) in

            maker.height.equalTo(parentView.heightPercentageOf(amount: itemInfo.separatorPercentage))
        }
        
        reloadCell()
    }
    
    override func onCreateViews() {
        super.onCreateViews()
    
    }
}


