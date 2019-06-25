//
//  HorizontalCellContainer.swift
//  Chefie
//
//  Created by user155921 on 5/22/19.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import UIKit
import SkeletonView

class HorizontalSectionCellBaseInfo : BaseItemInfo {
    
    var onTitleChanged: ((_ newValue : String) -> Void)!
    
    open func useDynamicTitle() -> Bool {
        
        return true
    }
    
    var titleValue : String = ""
    
    override func reuseIdentifier() -> String {
        return "HorizontalSectionView"
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

class HorizontalSectionView<T> : BaseCell, SkeletonCollectionViewDelegate, SkeletonCollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    var modelSet = Array<T>()
    
    let collectionView : UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        // layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumInteritemSpacing = 0.0
        let view = UICollectionView(frame: CGRect(x: 0, y: 0, width: 500, height: 200), collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.isDirectionalLockEnabled = false
        view.isPagingEnabled = true
        view.bounces = false
        view.delaysContentTouches = false
        // view.isUserInteractionEnabled = true
        view.alwaysBounceHorizontal = true
        view.alwaysBounceVertical = false
        view.isScrollEnabled = true
        // view.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
        return view
    }()
    
    let sectionActionButton : UIImageView = {
        
        let view = UIImageView(maskConstraints: false)
        view.image = UIImage(named: "arrow_right")
        view.frame = CGRect(x: 0, y: 0, width: 18, height: 18)
        view.contentMode = ContentMode.scaleToFill
        return view
    }()
    
    var sectionTitleStr : String = "Vertical Section"
    
    let titleLabel : PaddingLabel = {
        let lbl = PaddingLabel(maskConstraints: false, font: DefaultFonts.DefaultHeaderTextFont)
        lbl.text = ""
        lbl.textAlignment = .left
        lbl.numberOfLines = 1
        lbl.leftInset = AppSettings.HeaderLeftMargin
        //        lbl.backgroundColor = UIColor.red
        return lbl
    }()
    
    let stackView : UIStackView = {
        
        let stack = UIStackView(maskConstraints: false)
        stack.axis = .vertical
        stack.distribution = UIStackView.Distribution.fillProportionally
        stack.spacing = UIStackView.spacingUseSystem
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 0, left: AppSettings.DefaultViewMargin, bottom: 0, right: AppSettings.DefaultViewMargin)
        return stack
    }()
    
    open func registerCell() {
        
    }
    
    func setActionButtonImage(image : UIImage){
        self.sectionActionButton.image = image
    }
    
    func setActionButtonSize(size : CGSize = CGSize(width: 20, height: 20)){
        
        self.sectionActionButton.frame.size = size
        self.sectionActionButton.snp.updateConstraints { (maker) in
            
            maker.width.height.equalTo(size)
            maker.left.equalTo(parentView.getWidth().minusWithoutPercentage(amount: size.width + (size.width / 2)))
        }
    }
    
    func getCellIdentifier() -> String {
        return "HorizontallCellBase"
    }
    
    override func setModel(model: AnyObject?) {
        
        if model != nil {
            self.modelSet = (model as? Array<T>)!
        }
    }
    
    open func getSeeAllButtonSize() -> CGSize {
        
        return CGSize(width: 18, height: 18)
    }
    
    override func setBaseItemInfo(info: BaseItemInfo) {
        super.setBaseItemInfo(info: info)
        
        guard let horizontalSectionlInfo = info as? HorizontalSectionCellBaseInfo else {
            return
        }
        
        if (horizontalSectionlInfo.useDynamicTitle()){
            
            setSectionTitle(newTitle: horizontalSectionlInfo.titleValue)
            horizontalSectionlInfo.onTitleChanged = {(value: String) in
                self.setSectionTitle(newTitle: value)
            }
        }
        else {
            setSectionTitle(newTitle: horizontalSectionlInfo.title())
        }
    }
    
    func setSectionTitle(newTitle : String){
        
        sectionTitleStr = newTitle
        titleLabel.text = newTitle
    }
    
    override func onLayout(size: CGSize!) {
        super.onLayout(size: size)
        
        let cellSize = CGSize(width: onRequestItemSize().width, height: onRequestItemSize().height)
        
        let titleHeight = cellSize.heightPercentageOf(amount: 10)
        let collectionHeight = cellSize.heightPercentageOf(amount: 40)
        
        self.stackView.snp.makeConstraints { (maker) in
            
            maker.width.equalTo(size.width)
            maker.height.equalTo(cellSize.height)
        }
        
        titleLabel.snp.makeConstraints { (maker) in
            
            maker.width.equalTo(size.width.minus(amount: 20))
            maker.height.equalTo(titleHeight)
        }
        
        titleLabel.paletteDefaultTextColor()
        
        collectionView.snp.makeConstraints { (maker) in
            
            maker.width.equalTo(size.width)
            maker.height.equalTo(collectionHeight)
        }
        
        sectionActionButton.snp.makeConstraints { (maker) in
            
            maker.top.equalTo(0)
            maker.topMargin.equalTo(0)
            maker.width.height.equalTo(sectionActionButton.frame.size)
            maker.left.equalTo(size.width.minusWithoutPercentage(amount: sectionActionButton.getWidth() + (sectionActionButton.getWidth() / 2)))
        }
        
        self.contentView.snp.makeConstraints { (maker) in
            
            maker.width.equalTo(size.width)
            maker.height.equalTo(cellSize.height)
        }

        self.showAnimatedGradientSkeleton() 
    }
    
    func onLayoutSection() {
        
        collectionView.contentOffset = .zero
        collectionView.contentSize = CGSize(width: onRequestItemSize().width * CGFloat(modelSet.count), height: onRequestItemSize().height - 10)
        
        let content = CGSize(width: onRequestItemSize().width * CGFloat(modelSet.count), height: onRequestItemSize().height)
        
        stackView.frame.size.width = parentView.getWidth()
        stackView.frame.size.height = content.height
        
        self.stackView.snp.makeConstraints { (maker) in
            
            maker.width.equalTo(parentView.getWidth())
            maker.height.equalTo(content.height)
        }
        
        //  collectionView.frame.size.width = content.width
        // collectionView.frame.size.height = content.height
    }
    
    override func onLoadData() {
        super.onLoadData()
        
        hideSkeleton()
        onLayoutSection()
        
        titleLabel.doFadeIn()
    }
    
    override func onCreateViews() {
        super.onCreateViews()
        
        registerCell()
        
        sectionActionButton.setTouch(target: self, selector: #selector(onSectionActionTouch))
        
        self.contentView.addSubview(stackView)
        self.stackView.addArrangedSubview(titleLabel)
        self.stackView.addArrangedSubview(collectionView)
        self.contentView.addSubview(sectionActionButton)
    }
    
    @objc func onSectionActionTouch() {
        
        print("See all")
    }
    
    open func interItemSpacing() -> CGFloat {
        
        return 0
    }
    
    open func verticalSpacing() -> CGFloat {
        
        return 10
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
        return CGSize(width: collectionView.getWidth() / 4, height: parentView.heightPercentageOf(amount: 28))
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
