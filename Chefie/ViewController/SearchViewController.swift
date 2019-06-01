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

class SearchViewController : UIViewController, DynamicViewControllerProto {
    
    private var tableviewPaginator: TableviewPaginatorEx?
    var tableItems: Array<BaseItemInfo> = []
    var tableCellRegistrator = TableCellRegistrator()
    
    @IBOutlet weak var mainTable: UITableView!
    @IBOutlet weak var tagListView: TagListView!
    
    func onSetup() {
        
         tableCellRegistrator.add(identifier: PlatoCellItemInfo().reuseIdentifier(), cellClass: PlatoCellView.self)
        tableCellRegistrator.add(identifier: CommentCellInfo().reuseIdentifier(), cellClass: CommentCell.self)
        
        tableCellRegistrator.registerAll(tableView: mainTable)
        
        tableviewPaginator = TableviewPaginatorEx.init(paginatorUI: self, delegate: self)
        tableviewPaginator?.initialSetup()
    }
    
    func onSetupViews() {
        
        mainTable.setDefaultSettings()
        tagListView.textFont = UIFont.systemFont(ofSize: 14)
        tagListView.alignment = .left // possible values are .Left, .Center, and .Right
        
        tagListView.addTag("TagListView")
        
        for i in 0...20 {
            tagListView.addTag("test: \(i)")
        }
    
        
      //  tagListView.insertTag("This should be the second tag", at: 1)

        self.mainTable.dataSource = self
        self.mainTable.isSkeletonable = true
        self.mainTable.delegate = self
    }
    
    func onLayout() {
        
       
    }
    
    func doSearch(query : String) {
        
        var comments = [String]()
        comments.append("Este es un comentario corto")
        comments.append("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.")
      
        comments.append("Vastness is bearable only through love take root and flourish radio telescope not a sunrise but a galaxyrise rings of Uranus a very small stage in a vast cosmic arena. Descended from astronomers Tunguska event the only home we've ever known two ghostly white figures in coveralls and helmets are soflty dancing realm of the galaxies across the centuries. Emerged into consciousness gathered by gravity two ghostly white figures in coveralls and helmets are soflty dancing concept of the number one the only home we've ever known dispassionate extraterrestrial observer and billions upon billions upon billions upon billions upon billions upon billions upon billions.")
        
        appContainer.plateRepository.getPlatos(idUser: "2WT9s7km17QdtIwpYlEZ") { (
            result: ChefieResult<[Plate]>) in
            
            switch result {
                
            case .success(let data):
                
                var items = [BaseItemInfo]()
                
                data.forEach({ (plate) in
                    
                    let platoInfo = PlatoCellItemInfo()
                    platoInfo.model = plate as AnyObject
                    
                    items.append(platoInfo)
                })
                

                var commentItems = [Comment]()
                comments.forEach({ (commentStr) in
                    
                    let comment = Comment()
                    comment.idUser = "Steven"
                    comment.content = commentStr
                    commentItems.append(comment)
                    let commentInfo = CommentCellInfo()
                    commentInfo.model = comment
                    items.append(commentInfo)
                })
                
//
//                self.mainTable.beginUpdates()
//
//
//
//                items.forEach({ (item) in
//
//                    self.tableItems.append(item)
//                    let indexPath:IndexPath = IndexPath(row:(self.tableItems.count - 1), section:0)
//                    self.mainTable.insertRows(at: [indexPath], with: .fade)
//                })
//
//
//                self.mainTable.endUpdates()

                self.tableItems = items
                self.mainTable.reloadData()
                break
            case .failure(_):
                break
            }
        }
    }
    
    func onLoadData() {
        
        doSearch(query: "")
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
        let itemsCount = tableItems.count == 0 ? AppSettings.DefaultSkeletonCellCount : tableItems.count
        
        let tableviewPagiantorLoadeMoreCells = (tableviewPaginator?.rowsIn(section: section) ?? 0)
      //  return itemsCount + tableviewPagiantorLoadeMoreCells
        
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
            ce.cellSize = CGSize(width: -1, height: mainTable.heightPercentageOf(amount: 30))
            ce.parentView = tableView
            return ce
        }
        
        let cellInfo = self.tableItems[indexPath.row]
        
        let ce : BaseCell = mainTable.dequeueReusableCell(withIdentifier: cellInfo.reuseIdentifier(), for: indexPath) as! BaseCell
        ce.viewController = self
        ce.cellSize = CGSize(width: -1, height: mainTable.heightPercentageOf(amount: 30))
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
        return true
    }
    
    func getPaginatedLoadMoreCellHeight(paginator: TableviewPaginatorEx) -> CGFloat {
        return 44
    }
    
    func getPaginatedLoadMoreCell(paginator: TableviewPaginatorEx) -> UITableViewCell {
        
        if let cell = mainTable.dequeueReusableCell(withIdentifier: "LoadingCell") as? LoadingCell {
            // customize your load more cell
            // i.e start animating the UIActivityIndicator inside of the cell
            return cell
        } else {
            return UITableViewCell.init()
        }
    }
    
    func getRefreshControlTintColor(paginator: TableviewPaginatorEx) -> UIColor {
        return UIColor.orange
    }
}

extension SearchViewController: TableviewPaginatorProtocol {
    func loadPaginatedData(offset: Int, shouldAppend: Bool, paginator: TableviewPaginatorEx) {
//        print("LOAD")
//
//        if (offset > 0){
//
//
//        }
//
//        doSearch(query: "")
//
//        tableviewPaginator?.incrementOffsetBy(delta: 2)
//        tableviewPaginator?.partialDataFetchingDone()
    }
}
