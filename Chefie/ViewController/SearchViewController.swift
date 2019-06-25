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
import SCLAlertView
import CRRefresh

enum SearchQueryInfo: String {
    case Users = "Users"
    case Plates = "Recipes"
    case Routes = "Routes"
}

class SearchViewController : UIViewController, DynamicViewControllerProto, TagListViewDelegate, UITextFieldDelegate {
    
    var tableItems: Array<BaseItemInfo> = []
    var tableCellRegistrator = TableCellRegistrator()
    var filterLabels = Array<String>()
    var endlessTableHelper : EndlessTableHelper!
    
    @IBOutlet weak var mainTable: UITableView!
    @IBOutlet weak var tagListView: TagListView!
    @IBOutlet weak var searchTextField: SpringTextField!
    
    func getSearchFilterView() -> UIView {
        return UINib(nibName: "SearchFilterXIB", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    var searchFilter = SearchFilter()
    
    //Metodo que abre el alert para el filtrado por comunidades.
    @IBAction func openFilter(_ sender: Any) {
        
        let appearance = SCLAlertView.SCLAppearance(
            kCircleIconHeight: 55.0, showCloseButton: false
        )
        
        let alertView = SCLAlertView(appearance: appearance)
        let view = getSearchFilterView() as! SearchFilterView
      
        view.setup()
        view.setFilter(filter: searchFilter)
        view.loadData()
        alertView.addButton("Apply") {
            self.searchFilter = view.getFilter()
            self.clear()
            self.doSearch()
        }
        
        alertView.addButton("Cancel") {
            
        }
        alertView.customSubview = view
        
        // alertView.showEdit("Edit", subTitle: "")
        alertView.showCustom("Filter", subTitle: "", color: UIColor(red: 0.9176, green: 0.6314, blue: 0.6039, alpha: 1.0), icon: UIImage.init(named: "filterIcon")!.imageWithColor(tintColor: UIColor.white))
    }
    
    func onSetup() {
        
        tableCellRegistrator.add(identifier: HomePlatoCellItemInfo().reuseIdentifier(), cellClass: HomePlatoCellView.self)
        tableCellRegistrator.add(identifier: UserSearchCellItemInfo().reuseIdentifier(), cellClass: UserSearchCell.self)
        tableCellRegistrator.add(identifier: SeparatorCellItemInfo().reuseIdentifier(), cellClass: SeparatorCell.self)
        
        tableCellRegistrator.registerAll(tableView: mainTable)
        
        endlessTableHelper = EndlessTableHelper(table: mainTable)
        endlessTableHelper.firstItemsCount = 8
        
        searchFilter.community = "catalunya"
        searchFilter.name = "Cataluña"
        searchFilter.collection = SearchQueryInfo.Plates.rawValue
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
        mainTable.setContentInset(top: 10)
        tagListView.textFont = DefaultFonts.DefaultTextFont
        tagListView.alignment = .left // possible values are .Left, .Center, and .Right
        
        self.tagListView.delegate = self
        self.mainTable.dataSource = self
        self.mainTable.isSkeletonable = true
        self.mainTable.delegate = self
        
        filterLabels.append(contentsOf: [SearchQueryInfo.Plates.rawValue, SearchQueryInfo.Users.rawValue, SearchQueryInfo.Routes.rawValue])

        searchTextField.delegate = self
        
        mainTable.frame = CGRect(x: 0, y: 0, width: self.view.getWidth(), height: self.view.getHeight())
        mainTable.snp.makeConstraints { (make) in
            
            make.top.equalTo(self.view.heightPercentageOf(amount: 19))
            make.width.equalTo(self.view.getWidth())
            make.height.equalTo(self.view.heightPercentageOf(amount: 72))
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        return true
    }
    
    func onLayout() {
        
        
    }
    
    func clear() {
     
        self.endlessTableHelper.isFirst = false
        self.endlessTableHelper.noData = false
        self.tableItems.removeAll()
        self.endlessTableHelper.reset(reloadNow : true)
    }
    
    func doSearch() {
        
        tagListView.removeAllTags()
        tagListView.addTags([searchFilter.collection, "Community : " + searchFilter.name])
        
        let collection = self.searchFilter.collection!
        let community = self.searchFilter.community!
        switch collection {
            
        case SearchQueryInfo.Users.rawValue:
            doSearchUsers(query: community)
            break
        case SearchQueryInfo.Plates.rawValue: doSearchPlates(query: community)
            break
        case SearchQueryInfo.Routes.rawValue: doSearchRoutes(query: community)
            break
        default:
            doSearchPlates(query: community)
        }
    }
    
    func doSearchUsers(query : String){
  
        appContainer.userRepository.getAllUsers(community: searchFilter.community) { (result: Result<[ChefieUser], Error>) in
            
            switch result {
                
            case .success(let data):
                
                if !data.isEmpty{
                    
                    let users = data.compactMap({ (user) -> UserSearchCellItemInfo? in
                        
                        let item = UserSearchCellItemInfo()
                        item.model = user
                        return item
                    })
                    
                    users.forEach({ (item) in
                        self.tableItems.append(item)
                    })
                    
                    self.endlessTableHelper.setCount(count: self.tableItems.count)
                    
                    self.mainTable.reloadData()
                }
                
                break
            case .failure(_):
                
                break
            }
        }
    }
    
    func doSearchPlates(query: String){
      
        appContainer.plateRepository.getPlatos(community: searchFilter.community) { (result : ChefieResult<[Plate]>) in
            
            switch result {
                
            case .success(let data):
                
                if !data.isEmpty{
                    
                    let plates = data.compactMap({ (user) -> HomePlatoCellItemInfo? in
                        
                        let item = HomePlatoCellItemInfo()
                        item.model = user
                        return item
                    })
                    
                    plates.forEach({ (item) in
                        
                        self.tableItems.append(item)
      
                        self.tableItems.append(SeparatorCellItemInfo())
    
                    })
                    
                     self.endlessTableHelper.setCount(count: self.tableItems.count)
                    
                    self.mainTable.reloadData()
                    
//                    self.endlessTableHelper.loadMoreItems(itemsCount: data.count, callback: {
//
//                        let plates = data.compactMap({ (user) -> HomePlatoCellItemInfo? in
//
//                            let item = HomePlatoCellItemInfo()
//                            item.model = user
//                            return item
//                        })
//
//                        plates.forEach({ (item) in
//
//                            self.tableItems.append(item)
//                            self.endlessTableHelper.insertRow(itemsCount: self.tableItems.count - 1)
//
//                            self.tableItems.append(SeparatorCellItemInfo())
//                            self.endlessTableHelper.insertRow(itemsCount: self.tableItems.count - 1)
//                        })
//
//                        self.endlessTableHelper.setCount(count: self.tableItems.count)
//                    })
                }
    
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
        navigationItem.title = "Discover"
        self.navigationController!.navigationBar.isTranslucent = true
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: DefaultFonts.ZapFinoXs]
        view.backgroundColor = .white
        onSetup()
        onSetupViews()

        doSearch()
    }
}

extension SearchViewController: SkeletonTableViewDataSource, SkeletonTableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return endlessTableHelper.getCount()
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return tableItems [indexPath.row].reuseIdentifier()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
