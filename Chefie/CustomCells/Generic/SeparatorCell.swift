import Foundation
import UIKit
import SnapKit
import SDWebImage

class SeparatorCellItemInfo : BaseItemInfo{
    
    override func reuseIdentifier() -> String {
        return "SeparatorCell"
    }
}

class SeparatorCell : BaseCell, ICellDataProtocol{
    
    typealias T = Never
    
    var model: Never?

    override func onLayout(size: CGSize!) {
        super.onLayout(size: size)
      
        self.contentView.snp.makeConstraints { (maker) in
            maker.left.top.right.bottom.equalTo(0)
            maker.width.equalTo(size.width)
            maker.height.equalTo(size.heightPercentageOf(amount: 3))
        }
        
       // self.contentView.backgroundColor = UIColor.red
    }
    
    override func onLoadData() {
        super.onLoadData()

    }
    
    override func onCreateViews() {
        super.onCreateViews()
    
    }
}


