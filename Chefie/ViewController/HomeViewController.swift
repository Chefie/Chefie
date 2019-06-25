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
    
    var newPlateSubscription : Disposable!
    var feedRetrieveInfo = RetrieveFeedInfo()
    func onSetup() {
        
        endlessTableHelper = EndlessTableHelper(table: mainTable)
        endlessTableHelper.firstItemsCount = 8
        mainTable.setDefaultSettings(shouldBounce: true)
        
        _ = EventContainer.shared.HomeSubject.subscribe { (event) in
            
            self.feedRetrieveInfo.reset()
            self.tableItems.removeAll()
            self.endlessTableHelper.reset()
   
            self.mainTable.cr.beginHeaderRefresh()
           // self.mainTable.cr.endLoadingMore()
        }
        
        newPlateSubscription = EventContainer.shared.NewPlateUploaded.subscribe { (event : Event<Plate>) in
            
            self.endlessTableHelper.loadMoreItems(itemsCount: 1, callback: {
                
                let item = HomePlatoCellItemInfo()
                item.model = event.element
                
                self.tableItems.insert(item, at: 0)
                
                self.endlessTableHelper.insertRow(itemsCount: self.tableItems.count - 1)
                self.endlessTableHelper.setCount(count: self.tableItems.count)
            })
        }
        
        tableCellRegistrator.add(identifier: HomePlatoCellItemInfo().reuseIdentifier(), cellClass: HomePlatoCellView.self)
        
        tableCellRegistrator.add(identifier: StoriesHorizontalItemInfo().reuseIdentifier(), cellClass: StoriesHorizontalView.self)
    }
    
    func onSetupViews(){
        
        mainTable.frame = CGRect(x: 0, y: 0, width: self.view.getWidth(), height: self.view.getHeight())
        mainTable.snp.makeConstraints { (make) in
            
            make.topMargin.equalTo(20)
            
            make.width.equalTo(self.view.getWidth())
            make.height.equalTo(self.view.getHeight())
        }
        
        view.backgroundColor = .white
        
        navigationItem.title = "Chefie"
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: DefaultFonts.ZapFino]
        
        self.mainTable.dataSource = self
        self.mainTable.isSkeletonable = true
        self.mainTable.delegate = self
    }
    
    func onLoadData() {
        
        
    }
    
    func onLayout() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
   // var first = false
    func loadStories() {
        //
        //        if (!first){
        //
        //            first = true
        //            let storiesSection = StoriesHorizontalItemInfo()
        //
        //            var stories = [Story]()
        //            storiesSection.setTitle(value: "Stories")
        //            let model = Story()
        //            model.media = Media(title: "Hola", url: appContainer.getUser().profileBackgroundPic!)
        //            model.user = appContainer.getUser().mapToUserMin()
        //
        //            stories.append(model)
        //            storiesSection.model = stories as AnyObject
        //            self.tableItems.insert(storiesSection, at: 0)
        //
        //        }
    }
    
    func loadFeed(loadingFromTop : Bool = false){
        
        print("Loading feed")
        
        appContainer.feedRepository.getFeed(userId: appContainer.getUser().id!, retrieveInfo: feedRetrieveInfo) { (result : ChefieResult<RetrieveFeedInfo>) in
            
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
                            
                            self.endlessTableHelper.setCount(count: self.tableItems.count)
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
        let itemsCount = endlessTableHelper.getCount()
        
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

