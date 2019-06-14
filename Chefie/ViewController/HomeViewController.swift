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

class HomeViewController: UIViewController, DynamicViewControllerProto {
    
    var tableItems = Array<BaseItemInfo>()
    var tableCellRegistrator = TableCellRegistrator()
    var endlessTableHelper : EndlessTableHelper!
    
    @IBOutlet var mainTable: UITableView!
    
    override func updateViewConstraints() {
        
        onSetupViews()
        
        super.updateViewConstraints()
    }
    
    var newPlateSubscription : Disposable!
    var feedRetrieveInfo = RetrieveFeedInfo()
    func onSetup() {
        
        endlessTableHelper = EndlessTableHelper(table: mainTable)
        
        mainTable.setDefaultSettings(shouldBounce: true)
        
        newPlateSubscription = EventContainer.shared.NewPlateUploaded.subscribe { (event : Event<Plate>) in
            
            self.endlessTableHelper.begin()
            
            let item = HomePlatoCellItemInfo()
            item.model = event.element
            
            self.tableItems.insert(item, at: 0)
            self.endlessTableHelper.insertRowAt(row: 0)
            self.endlessTableHelper.end()
        }
    }
    
    func onSetupViews(){
        
        mainTable.frame = CGRect(x: 0, y: 0, width: self.view.getWidth(), height: self.view.getHeight())
        mainTable.snp.makeConstraints { (make) in
            
            make.topMargin.equalTo(20)
            
            make.width.equalTo(self.view.getWidth())
            make.height.equalTo(self.view.getHeight())
        }
        
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
    }
    
    func onLoadData() {
        
        
    }
    
    func onLayout() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableCellRegistrator.add(identifier: HomePlatoCellItemInfo().reuseIdentifier(), cellClass: HomePlatoCellView.self)
        onSetup()
        onSetupViews()
        
        tableCellRegistrator.registerAll(tableView: mainTable)
        
        mainTable.cr.addFootRefresh(animator: NormalFooterAnimator()) {
            
            self.loadFeed(loadingFromTop: false)
        }
        
        mainTable.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in
            
            self?.loadFeed(loadingFromTop: true)
        }
        
        self.mainTable.cr.beginHeaderRefresh()
    }
    
    func loadFeed(loadingFromTop : Bool = false){
        
        print("Loading feed")
        
        appContainer.feedRepository.getFeed(userId:  appContainer.getUser().id!, retrieveInfo: feedRetrieveInfo) { (result : ChefieResult<RetrieveFeedInfo>) in
            
            switch result {
                
            case .success(let result) :
                
                self.feedRetrieveInfo.update(result: result)
                
                if let data = result.data{
                    
                    let items = data.compactMap({ (plate) -> HomePlatoCellItemInfo? in
                        let item = HomePlatoCellItemInfo()
                        item.model = plate
                        return item
                        
                    })
                    
                    self.endlessTableHelper.loadMoreItems(itemsCount: items.count
                        , callback: {
                            
                            items.forEach({ (item) in
                                
                                self.tableItems.append(item)
                                self.endlessTableHelper.insertRow(itemsCount: self.tableItems.count - 1)
                            })
                    })
                }
                
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
