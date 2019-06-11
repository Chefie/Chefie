
import Foundation
import UIKit
import SkeletonView

class VerticalTableSectionCellBaseInfo : BaseItemInfo {
    
    var onTitleChanged: ((_ newValue : String) -> Void)!
    
    open func useDynamicTitle() -> Bool {
        
        return true
    }
    
    var titleValue : String = ""
    
    override func reuseIdentifier() -> String {
        return "VerticalTableSectionView"
    }
    
    open func title() -> String {
        return ""
    }
    
    func setTitle(value : String)  {
        
        self.titleValue = value
        if (onTitleChanged != nil){
            self.onTitleChanged(value)
        }
    }
}

class VerticalTableSectionView<T> : BaseCell, SkeletonTableViewDataSource, SkeletonTableViewDelegate
{
    var modelSet = Array<T>()
    
    var sectionTitleStr : String = "Vertical Table Section"
    
    let sectionTitleLabel : PaddingLabel = {
        let lbl = PaddingLabel(maskConstraints: false, font: DefaultFonts.DefaultHeaderTextFont)
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.leftInset = AppSettings.HeaderLeftMargin
        return lbl
    }()
    
    let seeAllBtn : UIButton = {
        
        let view = UIButton(maskConstraints: false)
        view.setTitle("See all", for: .normal)
        view.setTitleColor(UIColor.black, for: .normal)
        return view
    }()
    
    var config : VerticalSectionConfig = VerticalSectionConfig()
    
    let tableView : UITableView = {

        let tableView = UITableView(maskConstraints: false)
        tableView.allowsSelection = false
        tableView.allowsMultipleSelection = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.alwaysBounceHorizontal = false
        tableView.alwaysBounceVertical = false
        tableView.bounces = false
        tableView.isScrollEnabled = false
        tableView.showsVerticalScrollIndicator = false
        tableView.isDirectionalLockEnabled = false
        tableView.isPagingEnabled = false
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        return tableView
    }()
    
    func getCellIdentifier() -> String {
        return String(describing: self)
    }
    
    override func setModel(model: AnyObject?) {
        self.modelSet = (model as? Array<T>)!
    }
    
    override func getModel() -> AnyObject? {
        return self.modelSet as AnyObject
    }
    
    open func getVisibleItemsCount() -> Int {
        
        return 0
    }
    
    override func setBaseItemInfo(info: BaseItemInfo) {
        super.setBaseItemInfo(info: info)
        
        guard let verticalSectionInfo = info as? VerticalTableSectionCellBaseInfo else {
            return
        }
        
        if (verticalSectionInfo.useDynamicTitle()){
            
            setSectionTitle(newTitle: verticalSectionInfo.titleValue)
            verticalSectionInfo.onTitleChanged = {(value: String) in
                self.setSectionTitle(newTitle: value)
            }
        }
        else {
            setSectionTitle(newTitle: verticalSectionInfo.title())
        }
    }
    
    func setSectionTitle(newTitle : String){
        
        sectionTitleStr = newTitle
        sectionTitleLabel.text = sectionTitleStr
    }
    
    override func onLayout(size: CGSize!) {
        super.onLayout(size: size)
        
        self.contentView.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalTo(0)
            maker.width.equalTo(size.width)
            maker.height.equalTo(size.heightPercentageOf(amount: 30))
        }
        
        sectionTitleLabel.snp.makeConstraints { (maker) in
            
            maker.top.equalTo(2)
            maker.topMargin.equalTo(config.headerMargin.top)
            maker.leftMargin.equalTo(config.headerMargin.left)
            maker.width.equalTo(size.width.minus(amount: 10))
        }
        
        seeAllBtn.snp.makeConstraints { (maker) in
            
            maker.leftMargin.equalTo(config.footerMargin.left)
            maker.rightMargin.equalTo(config.footerMargin.right)
         
            maker.bottom.equalTo(0)
        }

        tableView.frame = CGRect(x: 0, y: sectionTitleLabel.calculateTextHeight() + 10, width: size.width, height: size.heightPercentageOf(amount: 34))
        
   //     sectionTitleLabel.displayLines(height: size.heightPercentageOf(amount: 10))
        seeAllBtn.titleLabel?.defaultFooterTextFont(bold: true)
    }
    
    func onLayoutSection(count : Int = -1){
        
        let headerHeight = sectionTitleLabel.calculateTextHeight() + config.headerMargin.top
        
        let itemsCount = count != -1 ? count : getVisibleItemsCount()
     
        let collectionViewHeight = onRequestItemSize().height * CGFloat(itemsCount) + CGFloat(onRequestVerticalSpacing() * CGFloat(itemsCount))
        
        let footerButtonHeight = parentView.heightPercentageOf(amount: 4)
        
        let margin = CGFloat(4)
        
        tableView.frame.addY(value: margin)
        tableView.frame.size.height = collectionViewHeight
        
        tableView.contentSize = CGSize(width: parentView.getWidth(), height: collectionViewHeight)
      //  sectionTitleLabel.backgroundColor = UIColor.purple
        

        
        _ = headerHeight + collectionViewHeight + footerButtonHeight + config.footerMargin.top * 2 + 10

        self.contentView.snp.remakeConstraints { (maker) in
             maker.left.top.right.bottom.equalTo(0)
            maker.width.equalTo(parentView.getWidth())
            maker.height.equalTo(headerHeight + collectionViewHeight + footerButtonHeight + config.footerMargin.top * 2 + 10)
        }
 
        
        seeAllBtn.snp.remakeConstraints { (maker) in
  
//            maker.leftMargin.equalTo(config.footerMargin.left)
//            maker.rightMargin.equalTo(config.footerMargin.right)

            maker.height.equalTo(footerButtonHeight)
            maker.bottom.equalTo(0)
           maker.bottomMargin.equalTo(0)
       
            maker.centerX.equalToSuperview()
        }
        
        seeAllBtn.paletteDefaultTextColor()
        sectionTitleLabel.paletteDefaultTextColor()
        
        sectionTitleLabel.displayLines(height: headerHeight)
        
        seeAllBtn.setSkeleton()
        seeAllBtn.titleLabel?.setSkeleton()
        
        seeAllBtn.hide()
        
        tableView.isScrollEnabled = false
        //self.backgroundColor = UIColor.red
    }
    
    override func onCreateViews() {
        super.onCreateViews()
        
        onRegisterCells()
        
        self.contentView.addSubview(sectionTitleLabel)
        self.contentView.addSubview(tableView)
        self.contentView.addSubview(seeAllBtn)
    }
    
    override func onLoadData() {
        super.onLoadData()
        onLayoutSection()
    }
    
    func onReady(){
        
        seeAllBtn.show()
        sectionTitleLabel.doFadeIn()
        seeAllBtn.doFadeIn()
        
        sectionTitleLabel.restore()
    }
    
    open func interItemSpacing() -> CGFloat {
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return onRequestVerticalSpacing()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return onRequestItemSize().height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return onRequestNumberOfItemsInSection()
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return getCellIdentifier()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return onRequestCell(tableView, cellForItemAt: indexPath)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return onRequestNumberOfSections()
    }

    open func onRegisterCells() {
        
    }
    
    open func onRequestVerticalSpacing() -> CGFloat {
        return 0
    }
    
    open func onRequestNumberOfItemsInSection()  -> Int {
        
        return 3
    }
    
    open func onRequestNumberOfSections()  -> Int {
        
        return 1
    }
    
    open func onRequestItemSize() -> CGSize {
        return CGSize(width: tableView.getWidth(), height: self.parentView.getHeight().percentageOf(amount: 36))
    }

    open func onRequestCell(_ tableView: UITableView, cellForItemAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
}
