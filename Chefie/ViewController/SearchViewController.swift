//
//  SearchViewController.swift
//  Chefie
//
//  Created by DAM on 28/05/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import UIKit
import TagListView
import TableviewPaginator
import SkeletonView

enum SearchQueryInfo: String {
    case Users = "Users"
    case Plates = "Plates"
    case Routes = "Routes"
}

class SearchViewController : UIViewController, DynamicViewControllerProto, TagListViewDelegate, UITextFieldDelegate {
    
    private var tableviewPaginator: TableviewPaginatorEx!
    var tableItems: Array<BaseItemInfo> = []
    var tableCellRegistrator = TableCellRegistrator()
    var filterLabels = Array<String>()
    var endlessTableHelper : EndlessTableHelper!
    
    @IBOutlet weak var mainTable: UITableView!
    @IBOutlet weak var tagListView: TagListView!
    @IBOutlet weak var searchTextField: SpringTextField!
    
    func onSetup() {
        
         tableCellRegistrator.add(identifier: NewPlateMediaCellItemInfo().reuseIdentifier(), cellClass: NewPlateMediaCell.self)

        tableCellRegistrator.add(identifier: UserSearchCellItemInfo().reuseIdentifier(), cellClass: UserSearchCell.self)
        
        tableCellRegistrator.registerAll(tableView: mainTable)

        tableviewPaginator = TableviewPaginatorEx.init(paginatorUI: self, delegate: self)
        tableviewPaginator.initialSetup()
        
        endlessTableHelper = EndlessTableHelper(table: mainTable, paginator: tableviewPaginator)
        endlessTableHelper.firstItemsCount = 0
    }
    
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        
        tagListView.tagViews.forEach { (tagView) in
            tagView.isSelected = false
        }
        
        tagView.isSelected = true
        self.clear()
        self.doSearch()
    }
    
    func onSetupViews() {
        
        mainTable.setDefaultSettings()
        tagListView.textFont = DefaultFonts.DefaultTextFont
        tagListView.alignment = .left // possible values are .Left, .Center, and .Right
        
        self.tagListView.delegate = self
        self.mainTable.dataSource = self
        self.mainTable.isSkeletonable = true
        self.mainTable.delegate = self
        
        filterLabels.append(contentsOf: [SearchQueryInfo.Plates.rawValue, SearchQueryInfo.Users.rawValue, SearchQueryInfo.Routes.rawValue])
        tagListView.addTags(filterLabels)
        tagListView.tagViews[1].isSelected = true
        
        searchTextField.delegate = self
        
        mainTable.snp.makeConstraints { (make) in
            
            make.left.equalTo(0)
            make.top.equalTo(self.view.heightPercentageOf(amount: 20))
            //    make.topMargin.equalTo(50)
            make.width.equalTo(self.view.getWidth())
            make.height.equalTo(self.view.heightPercentageOf(amount: 80))
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        return true
    }
    
    func onLayout() {
        
       
    }
    
    func clear() {
        
        let count = tableItems.count
        self.tableItems.removeAll()
        self.mainTable.reloadData()
      //  self.endlessTableHelper.removeRows(count: count)
      //  self.mainTable.reloadData()
    }
    
    func doSearch() {
        
        let query = self.searchTextField.text ?? ""
        let tagView = tagListView.selectedTags().first
        let tagValue = tagView?.titleLabel?.text
        switch tagValue {

            case SearchQueryInfo.Users.rawValue:
                doSearchUsers(query: query)
                break
            case SearchQueryInfo.Plates.rawValue: doSearchPlates(query: query)
                break
            case SearchQueryInfo.Routes.rawValue: doSearchRoutes(query: query)
                break
        default:
            doSearchPlates(query: query)
        }
    }
    
    func doSearchUsers(query : String){
        appContainer.userRepository.getAllUsers(offset: 10) { (result: Result<[ChefieUser], Error>) in
            
            switch result {
                
            case .success(let data):
                
                self.endlessTableHelper.loadMoreItems(itemsCount: data.count, callback: {
                    
                    let users = data.compactMap({ (user) -> UserSearchCellItemInfo? in
                        
                        let item = UserSearchCellItemInfo()
                        item.model = user
                        return item
                    })
                    
                    users.forEach({ (item) in
                        
                        self.tableItems.append(item)
                        self.endlessTableHelper.insertRow(itemsCount: self.tableItems.count - 1, item: item)
                    })
                })
                
                break
            case .failure(_):
                
                break
            }
        }
    }

    func doSearchPlates(query: String){
        
        appContainer.plateRepository.getPlatos { (result : ChefieResult<[Plate]>) in
            
            switch result {
                
            case .success(let data):
                
                self.endlessTableHelper.loadMoreItems(itemsCount: data.count, callback: {
                    
                    let plates = data.compactMap({ (user) -> NewPlateMediaCellItemInfo? in
                        
                        let item = NewPlateMediaCellItemInfo()
                        item.model = user
                        return item
                    })
                    
                    plates.forEach({ (item) in
                        
                        self.tableItems.append(item)
                        self.endlessTableHelper.insertRow(itemsCount: self.tableItems.count - 1, item: item)
                    })
                    
                })
                
                break
            case .failure(_):
                
                break
            }
        }
    }
    
    func doSearchRoutes(query : String){
    
    }
    
    func onLoadData() {
        

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        onSetup()
        onSetupViews()
        onLoadData()
    }
}

extension SearchViewController: SkeletonTableViewDataSource, SkeletonTableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if let height = tableviewPaginator?.heightForLoadMore(cell: indexPath) {
            return height
        }
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    ///    let itemsCount = tableItems.count == 0 ? AppSettings.DefaultSkeletonCellCount : tableItems.count
        
//        let tableviewPagiantorLoadeMoreCells = (tableviewPaginator?.rowsIn(section: section) ?? 0)
//      //  return itemsCount + tableviewPagiantorLoadeMoreCells
//
         return tableItems.count
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return tableItems [indexPath.row].reuseIdentifier()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if let cell = tableviewPaginator?.cellForLoadMore(at: indexPath) {
//            return cell
//        }
//
        if (self.tableItems.count == 0){
            let ce : BaseCell = mainTable.dequeueReusableCell(withIdentifier: tableCellRegistrator.getRandomIdentifier(), for: indexPath) as! BaseCell
            ce.viewController = self
          //  ce.cellSize =
            ce.parentView = tableView
            return ce
        }
        
        let cellInfo = self.tableItems[indexPath.row]
        
        let ce : BaseCell = mainTable.dequeueReusableCell(withIdentifier: cellInfo.reuseIdentifier(), for: indexPath) as! BaseCell
        ce.viewController = self
      //  ce.cellSize = CGSize(width: -1, height: mainTable.heightPercentageOf(amount: 30))
        ce.parentView = tableView
        ce.setBaseItemInfo(info: cellInfo)
        ce.setModel(model: cellInfo.model)
        ce.onLoadData()
        return ce
    }
}

extension SearchViewController: TableviewPaginatorUIProtocol {
    func getTableview(paginator: TableviewPaginatorEx) -> UITableView {
        return mainTable
    }
    
    func shouldAddRefreshControl(paginator: TableviewPaginatorEx) -> Bool {
        return false
    }
    
    func getPaginatedLoadMoreCellHeight(paginator: TableviewPaginatorEx) -> CGFloat {
        return mainTable.heightPercentageOf(amount: 20)
    }
    
    func getPaginatedLoadMoreCell(paginator: TableviewPaginatorEx) -> UITableViewCell {
        
        return UITableViewCell.init()
    }
    
    func getRefreshControlTintColor(paginator: TableviewPaginatorEx) -> UIColor {
        return UIColor.orange
    }
}

extension SearchViewController: TableviewPaginatorProtocol {
    func loadPaginatedData(offset: Int, shouldAppend: Bool, paginator: TableviewPaginatorEx) {

        
    }
}
