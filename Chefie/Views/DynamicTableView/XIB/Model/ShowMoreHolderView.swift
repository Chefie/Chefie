//
//  ShowMoreHolder.swift
//  Chefie
//
//  Created by Steven on 29/04/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import UIKit
import SkeletonView

class ShowMoreHolderView<T> : UIView, SkeletonTableViewDataSource, SkeletonTableViewDelegate {
    
    var onRequestCell: ((_ cellIdentifier: String, _ tableView : UITableView, _ indexPath: IndexPath, _ data: Any,  _ dataLength : Int) -> UITableViewCell)?
    
    var data : Array<T>?
    
    @IBOutlet var contentStackView: UIStackView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var showMoreBtn: UIButton!
    
    var cellIdentifier : String!
    
    init(frame: CGRect, cellIdentifier: String) {
        super.init(frame: frame)
        self.cellIdentifier = cellIdentifier
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func doLayout(){
        
         tableView.rowHeight = UITableView.automaticDimension
        
    
        lblTitle.frame = CGRect()
        lblTitle.snp.makeConstraints { (maker) in
            maker.left.equalTo(10)
            maker.width.equalTo(self.getWidth())
            maker.height.equalTo(self.getHeight().percentageOf(amount: 10))
        }
        
        tableView.backgroundColor = UIColor.red
              contentStackView.translatesAutoresizingMaskIntoConstraints = false;
        tableView.snp.makeConstraints { (maker) in

            maker.left.equalTo(0)
            maker.width.equalTo(self.getWidth())
            maker.height.equalTo(self.getHeight().percentageOf(amount: 90))
        }
        
        self.tableView.dataSource = self
        self.tableView.isSkeletonable = true
        self.tableView.delegate = self
        self.tableView.alwaysBounceVertical = false
        self.tableView.alwaysBounceHorizontal = false
        self.tableView.isScrollEnabled = false
        
        showMoreBtn.snp.makeConstraints { (maker) in
            maker.width.equalTo(self.getWidth())
            maker.height.equalTo(self.getHeight().percentageOf(amount: 10))
        }
    }
    
    func reloadCells(){
    
        tableView.reloadData()
    }
    
    func releaseNow(){
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("ShowMoreHolderView", owner: self, options: nil)
        contentStackView.fixInView(self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.heightPercentageOf(amount: CGFloat(33.5))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count == 0 ? 10 : data?.count ?? 0
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return cellIdentifier
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dataModel = self.data?[indexPath.row]
        let cell = onRequestCell!(cellIdentifier, tableView, indexPath, dataModel ?? T.self, data?.count ?? 0)
        return cell
    }
}
