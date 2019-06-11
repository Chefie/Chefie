import Foundation
import UIKit
import Firebase
import GoogleSignIn
import SkeletonView
import SDWebImage
import TableviewPaginator
import AWSS3
import AWSCore
import RxSwift
import CRRefresh

let PlateCellIdentifier = "PlateCellView"

class HomeViewController: UIViewController, DynamicViewControllerProto {
    
    var tableviewPaginator: TableviewPaginatorEx!
    var tableItems = Array<BaseItemInfo>()
    var tableCellRegistrator = TableCellRegistrator()
    var endlessTableHelper : EndlessTableHelper!
    
    @IBOutlet var mainTable: UITableView!
    
    var followingRetrieveResult = RetrieveFollowingInfo()
    var platesRetrieveResult = RetrievePlatesInfo()
    
    override func updateViewConstraints() {
        
        onSetupViews()
        
        super.updateViewConstraints()
    }
    
    func onSetup() {

       endlessTableHelper = EndlessTableHelper(table: mainTable)
        
        mainTable.setDefaultSettings(shouldBounce: true)
        
        appContainer.plateRepository.getPlatos { (result : ChefieResult<[Plate]>) in
            switch result {
                
            case .success(let data):
                
                let items = data.compactMap({ (plate) -> HomePlatoCellItemInfo? in
                    let item = HomePlatoCellItemInfo()
                    item.model = plate
                    return item
                    
                })
                
                
                //self.mainTable.reloadData()
                self.endlessTableHelper.loadMoreItems(itemsCount: items.count
                    , callback: {
                        
                        items.forEach({ (item) in
                            
                            self.tableItems.append(item)
                            self.endlessTableHelper.insertRow(itemsCount: self.tableItems.count - 1)
                        })
                })
                //
                break
            case .failure(_):
                break
            }
            
       
            self.mainTable.cr.endHeaderRefresh()

        }
        
//        appContainer.userRepository.getFollowingUsers(idUser: appContainer.getUser().id!, request: followingRetrieveResult) { (result : ChefieResult<RetrieveFollowingInfo>) in
//
//            switch result {
//                
//            case .success(let result):
//                
//                self.followingRetrieveResult.update(result: result)
//                print("")  
//                break
//            case .failure(_): break
//            }
//        }
//        
//        appContainer.plateRepository.getPlatos(idUser: appContainer.getUser().id!, request: platesRetrieveResult) { (result : ChefieResult<RetrievePlatesInfo>) in
//            switch result {
//                
//            case .success(let result):
//                
//                self.platesRetrieveResult.update(result: result)
//                print("")
//                
//                break
//            case .failure(_): break
//            }
//        }
//        
//        appContainer.dataManager.remoteData.NewPlateSubject.subscribe { (
//            event : Event<Plate>) in
//            
//            self.endlessTableHelper.begin()
//            
//            let item = HomePlatoCellItemInfo()
//            item.model = event.element
//            
//            self.tableItems.insert(item, at: 0)
//            self.endlessTableHelper.insertRowAt(row: 0)
//            self.endlessTableHelper.end()
//        }
    }
    
    func onSetupViews(){
        
      //  mainTable.backgroundColor = UIColor.red
        
        mainTable.frame = CGRect(x: 0, y: 0, width: self.view.getWidth(), height: self.view.getHeight())
        mainTable.snp.makeConstraints { (make) in
            
            make.topMargin.equalTo(20)
            
            make.width.equalTo(self.view.getWidth())
            make.height.equalTo(self.view.getHeight())
        }

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //       tableviewPaginator.scrollViewDidScroll(scrollView)
    }
    
    func onLoadData() {
        
     
    }
    
    func onLayout() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainTable.register(LoadingCell.self, forCellReuseIdentifier: "LoadingCell")
        
        tableCellRegistrator.add(identifier: HomePlatoCellItemInfo().reuseIdentifier(), cellClass: HomePlatoCellView.self)
        onSetup()
        onSetupViews()
        
        tableCellRegistrator.registerAll(tableView: mainTable)
        
        navigationItem.title = "Chefie"
        //Custom navigationItem (Title) font Zapfino
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: DefaultFonts.ZapFino]
        
        view.backgroundColor = .white
        
        //self.mainTable.delegate = self as! UITableViewDelegate
        self.mainTable.dataSource = self
        self.mainTable.isSkeletonable = true
        self.mainTable.delegate = self
        
        self.mainTable.alwaysBounceVertical = false
        self.mainTable.alwaysBounceHorizontal = false

       // self.loadPlates()
        
        mainTable.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in

            self?.loadPlates()
        }
        
        
        mainTable.cr.addFootRefresh(animator: NormalFooterAnimator()) {
            
        }
        
        self.mainTable.cr.beginHeaderRefresh()
    }
    
    @IBAction func onTouchsss(_ sender: UIButton) {
    }
    
    @IBAction func btnTap(_ sender: Any) {
        
        //       let item = self.tableItems[1].model as? Comment
        //      item?.content = "La celda se debe adaptar al texto"
        //
        //      mainTable.reloadRows(at: [IndexPath(item:1 , section: 0)], with: .none)
    }
    
    var section = 0
    var isFirst = false
    
    func loadPlates(){
        
        print("Loading plates")

        appContainer.plateRepository.getPlatos { (result : ChefieResult<[Plate]>) in
            switch result {
                
            case .success(let data):
                
                let items = data.compactMap({ (plate) -> HomePlatoCellItemInfo? in
                    let item = HomePlatoCellItemInfo()
                    item.model = plate
                    return item
                    
                })
                
                
                //self.mainTable.reloadData()
                self.endlessTableHelper.loadMoreItems(itemsCount: items.count
                    , callback: {

                        items.forEach({ (item) in

                            self.tableItems.append(item)
                            self.endlessTableHelper.insertRow(itemsCount: self.tableItems.count - 1)
                        })
                })
                break
            case .failure(_):
                break
            }
            
            self.mainTable.cr.endHeaderRefresh()
        }
    }
}

extension HomeViewController: SkeletonTableViewDataSource, SkeletonTableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let itemsCount = tableItems.count == 0 ? AppSettings.DefaultSkeletonCellCount : tableItems.count

        return itemsCount
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return tableItems [indexPath.row].reuseIdentifier()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if (self.tableItems.count == 0){
            let ce : BaseCell = mainTable.dequeueReusableCell(withIdentifier: tableCellRegistrator.getRandomIdentifier(), for: indexPath) as! BaseCell
            ce.viewController = self
            ce.parentView = tableView
            return ce
        }
        
        let cellInfo = self.tableItems[indexPath.row]
        
        let ce : BaseCell = mainTable.dequeueReusableCell(withIdentifier: cellInfo.reuseIdentifier(), for: indexPath) as! BaseCell
        ce.viewController = self
        ce.parentView = tableView
        ce.setBaseItemInfo(info: cellInfo)
        ce.setModel(model: cellInfo.model)
        ce.onLoadData()
        return ce
    }
}

class LoadingCell : UITableViewCell {
    
    let loading : MultilineLabel = {
        let lbl = MultilineLabel(maskConstraints: false, font: DefaultFonts.DefaultTextFont)
        lbl.text = "Loading...."
        lbl.numberOfLines = 1
        return lbl
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(loading)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeViewController: TableviewPaginatorUIProtocol {
    func getTableview(paginator: TableviewPaginatorEx) -> UITableView {
        return mainTable
    }
    
    func shouldAddRefreshControl(paginator: TableviewPaginatorEx) -> Bool {
        return false
    }
    
    func getPaginatedLoadMoreCellHeight(paginator: TableviewPaginatorEx) -> CGFloat {
        return 0
    }
    
    func getPaginatedLoadMoreCell(paginator: TableviewPaginatorEx) -> UITableViewCell {
        return UITableViewCell.init()
    }
    
    func getRefreshControlTintColor(paginator: TableviewPaginatorEx) -> UIColor {
        return UIColor.orange
    }
}
