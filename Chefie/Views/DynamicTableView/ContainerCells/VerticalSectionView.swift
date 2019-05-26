//
//  VerticalSectionView.swift
//  Chefie
//
//  Created by DAM on 23/05/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import UIKit
import SkeletonView

class VerticalSectionCellBaseInfo : BaseItemInfo {
    
    var onTitleChanged: ((_ newValue : String) -> Void)!
    
    open func useDynamicTitle() -> Bool {
        
        return true
    }
    
    var titleValue : String = ""
    
    override func reuseIdentifier() -> String {
        return "VerticalSectionView"
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

struct VerticalSectionConfig {
    
    var footerMargin : CFMargin = CFMargin(left: 0, top: 0, right: 0, bottom: 2)
    var headerMargin : CFMargin = CFMargin(left: 0, top: 6, right: 0, bottom: 0)
    var contentMargin : CFMargin = CFMargin(left: 4, top: 4, right: 4, bottom: 4)
}

class VerticalSectionView<T> : BaseCell,  SkeletonCollectionViewDelegate, SkeletonCollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    var modelSet = Array<T>()

    var sectionTitleStr : String = "Vertical Section"
    
    let sectionTitleLabel : PaddingLabel = {
        let lbl = PaddingLabel(maskConstraints: false, font: DefaultFonts.DefaultHeaderTextBoldFont)
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.leftInset = 0
        return lbl
    }()
    
    let seeAllBtn : UIButton = {
        
        let view = UIButton(maskConstraints: false)
        view.setTitle("See all", for: .normal)
        view.setTitleColor(UIColor.black, for: .normal)
        return view
    }()
    
    var config : VerticalSectionConfig = VerticalSectionConfig()
    
    let collectionView : UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
    //    layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layout.minimumInteritemSpacing = 0.0

        let view = UICollectionView(frame: CGRect(x: 0, y: 0, width: 500, height: 200), collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.isDirectionalLockEnabled = false
        view.isPagingEnabled = false
        view.bounces = false
        view.delaysContentTouches = false
        view.alwaysBounceHorizontal = false
        view.alwaysBounceVertical = false
        view.isScrollEnabled = false
        return view
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

        guard let verticalSectionInfo = info as? VerticalSectionCellBaseInfo else {
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
  
        sectionTitleLabel.snp.makeConstraints { (maker) in
            
           maker.topMargin.equalTo(config.headerMargin.top)
           maker.centerX.equalToSuperview()
           maker.width.equalTo(size.width.minus(amount: 10))
        }
        
       // titleLabel.backgroundColor = UIColor.gray
        
    //   titleLabel.backgroundColor = UIColor.orange
        
        collectionView.frame = CGRect(x: 0, y: sectionTitleLabel.calculateTextHeight() + 10, width: size.width, height: size.heightPercentageOf(amount: 34))

        //titleLabel.text = "Vertical Section"

        sectionTitleLabel.displayLines(height: size.heightPercentageOf(amount: 10))
       seeAllBtn.titleLabel?.defaultFooterTextFont(bold: true)
        
       //collectionView.backgroundColor = UIColor.green
    }
    
    func onLayoutSection(){

        let headerHeight = sectionTitleLabel.calculateTextHeight() + config.headerMargin.top
        
        let collectionViewHeight = onRequestItemSize().height * CGFloat(getVisibleItemsCount()) + CGFloat(verticalSpacing()  * CGFloat(getVisibleItemsCount()))
        
        let footerButtonHeight = parentView.heightPercentageOf(amount: 4)
        
        let margin = CGFloat(4)
        
        collectionView.frame.addY(value: margin)
        collectionView.frame.size.height = collectionViewHeight

        seeAllBtn.snp.makeConstraints { (maker) in
            
            maker.bottom.equalTo(0)
            maker.leftMargin.equalTo(config.footerMargin.left)
            maker.topMargin.equalTo(config.footerMargin.top * 2)
            maker.rightMargin.equalTo(config.footerMargin.right)
            maker.bottomMargin.equalTo(config.footerMargin.bottom)

            maker.centerX.equalToSuperview()
         //   maker.width.equalTo(parentView.widthPercentageOf(amount: 20))
            maker.height.equalTo(footerButtonHeight)
        }
        
        self.contentView.snp.makeConstraints { (maker) in
            
            maker.width.equalTo(parentView.getWidth())
            maker.height.equalTo(headerHeight + collectionViewHeight + footerButtonHeight + config.footerMargin.top * 2 + 10)
            
        }
        
        //self.sectionTitleLabel.backgroundColor = UIColor.orange
      //  self.contentView.backgroundColor = UIColor.red
        
        seeAllBtn.paletteDefaultTextColor()
        sectionTitleLabel.paletteDefaultTextColor()

        sectionTitleLabel.displayLines(height: headerHeight)
        
        seeAllBtn.setSkeleton()
        seeAllBtn.titleLabel?.setSkeleton()
        
        seeAllBtn.hide()
    }
    
    override func onCreateViews() {
        super.onCreateViews()
        
        onRegisterCells()
        
        self.contentView.addSubview(sectionTitleLabel)
        self.contentView.addSubview(collectionView)
        self.contentView.addSubview(seeAllBtn)
    }
    
    override func onLoadData() {
        super.onLoadData()
        onLayoutSection()
        
        sectionTitleLabel.doFadeIn()
        seeAllBtn.doFadeIn()
    }
    
    open func interItemSpacing() -> CGFloat {
        
        return 0
    }
    
    open func verticalSpacing() -> CGFloat {
        
        return 10
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    
        return verticalSpacing()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interItemSpacing()
    }
    
    open func onRegisterCells() {
        
    }

    open func onRequestNumberOfItemsInSection()  -> Int {
        
        return modelSet.count
    }
    
    open func onRequestNumberOfSections()  -> Int {
        
        return 1
    }
    
    open func onRequestItemSize() -> CGSize {
        return CGSize(width: collectionView.getWidth().minus(amount: 10), height: collectionView.getHeight())
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onRequestNumberOfItemsInSection()
    }
    
    func numSections(in collectionSkeletonView: UICollectionView) -> Int {
        return onRequestNumberOfSections()
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        
        return getCellIdentifier()
    }
    
    open func onRequestCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return onRequestCell(collectionView, cellForItemAt: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return onRequestItemSize()
    }
}
