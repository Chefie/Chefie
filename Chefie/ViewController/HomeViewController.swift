import Foundation
import UIKit
import Firebase
import GoogleSignIn
import SkeletonView
import SDWebImage
import TableviewPaginator
import AWSS3
import AWSCore

let PlateCellIdentifier = "PlateCellView"

class HomeViewController: UIViewController, DynamicViewControllerProto {
  
    var tableviewPaginator: TableviewPaginatorEx!
    var tableItems = Array<BaseItemInfo>()
    var tableCellRegistrator = TableCellRegistrator()
    var endlessTableHelper : EndlessTableHelper!
    
    @IBOutlet weak var mainTable: UITableView!{
        didSet {

            mainTable.setDefaultSettings()
        }
    }
    
    override func updateViewConstraints() {
   
        onSetupViews()
        
        super.updateViewConstraints()
    }
    
    func onSetup() {
//        let cache = ImageCache.default
//        cache.clearMemoryCache()
//        cache.clearDiskCache()
//        
     //   SDImageCache.shared.clearMemory()
       // SDImageCache.shared.clearDisk()
        tableviewPaginator = TableviewPaginatorEx.init(paginatorUI: self, delegate: self)
        tableviewPaginator.initialSetup()
        endlessTableHelper = EndlessTableHelper(table: mainTable, paginator: tableviewPaginator)
    }
    
    func onSetupViews(){
        
        mainTable.backgroundColor = UIColor.white
        mainTable.snp.makeConstraints { (make) in
            
        //    make.topMargin.equalTo(50)
            make.width.equalTo(self.view.getWidth())
            make.height.equalTo(self.view.getHeight())
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        tableviewPaginator.scrollViewDidScroll(scrollView)
    }
    
    func onLoadData() {

    }
    
    func onLayout() {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
 
        mainTable.register(LoadingCell.self, forCellReuseIdentifier: "LoadingCell")
        
        //tableCellRegistrator.add(identifier: CommentsHorizontalCellInfo().reuseIdentifier(), cellClass: CommentsHorizontalCell.self)
        tableCellRegistrator.add(identifier: NewPlateMediaCellItemInfo().reuseIdentifier(), cellClass: NewPlateMediaCell.self)
        onSetup()
        onSetupViews()
        
     
        

     //tableCellRegistrator.add(identifier: PlatoCellItemInfo().reuseIdentifier(), cellClass: PlatoCellView.self)
       // tableCellRegistrator.add(identifier: CommentCellInfo().reuseIdentifier(), cellClass: CommentCell.self)
    

//        registeredCells.append( PlatoCellItemInfo().identifier(), MediaCellView.self)

        tableCellRegistrator.registerAll(tableView: mainTable)

        navigationItem.title = "Chefie"
        //Custom navigationItem (Title) font Zapfino
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Zapfino", size: 18)!]

        view.backgroundColor = .white
        
        //self.mainTable.delegate = self as! UITableViewDelegate
        self.mainTable.dataSource = self
        self.mainTable.isSkeletonable = true
        self.mainTable.delegate = self

        self.mainTable.alwaysBounceVertical = false
        self.mainTable.alwaysBounceHorizontal = false
        
     // loadPlates()
        
        onLoadData()
    }

    @IBAction func onTouchsss(_ sender: UIButton) {
    }
    @IBAction func btnTap(_ sender: Any) {
        
       let item = self.tableItems[1].model as? Comment
      item?.content = "La celda se debe adaptar al texto"
        
      mainTable.reloadRows(at: [IndexPath(item:1 , section: 0)], with: .none)
        print("")
    }

    var section = 0
    var isFirst = false
    
    func loadPlates(){
        
        var comments = [String]()
        comments.append("Este es un comentario corto")
        comments.append("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.")
        comments.append("Five hours? Aw, man! Couldn't you just get me the death penalty?")
        comments.append("Five hours? Aw, man! Couldn't you just get me the death penalty?")
        comments.append("Five hours? Aw, man! Couldn't you just get me the death penalty?")
        comments.append("Five hours? Aw, man! Couldn't you just get me the death penalty?")
        comments.append("Vastness is bearable only through love take root and flourish radio telescope not a sunrise but a galaxyrise rings of Uranus a very small stage in a vast cosmic arena. Descended from astronomers Tunguska event the only home we've ever known two ghostly white figures in coveralls and helmets are soflty dancing realm of the galaxies across the centuries. Emerged into consciousness gathered by gravity two ghostly white figures in coveralls and helmets are soflty dancing concept of the number one the only home we've ever known dispassionate extraterrestrial observer and billions upon billions upon billions upon billions upon billions upon billions upon billions.")

        appContainer.plateRepository.getPlatos { (result : ChefieResult<[Plate]>) in
            switch result {
                
            case .success(let data):
                
               let items = data.compactMap({ (plate) -> NewPlateMediaCellItemInfo? in
                    let item = NewPlateMediaCellItemInfo()
                    item.model = plate
                    return item
                    
                })
        
                self.endlessTableHelper.loadMoreItems(itemsCount: items.count
                    , callback: {
                        
                        items.forEach({ (item) in
                            
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
}

extension HomeViewController: SkeletonTableViewDataSource, SkeletonTableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if let height = tableviewPaginator.heightForLoadMore(cell: indexPath) {
            return height
        }
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let itemsCount = tableItems.count == 0 ? AppSettings.DefaultSkeletonCellCount : tableItems.count
        
   //     let tableviewPagiantorLoadeMoreCells = (tableviewPaginator?.rowsIn(section: section) ?? 0)
        return itemsCount
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return tableItems [indexPath.row].reuseIdentifier()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableviewPaginator.cellForLoadMore(at: indexPath) {
            return cell
        }

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
        //lbl.textColor = UIColor.white
        //lbl.backgroundColor = UIColor.blue
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
        return true
    }
    
    func getPaginatedLoadMoreCellHeight(paginator: TableviewPaginatorEx) -> CGFloat {
        return 44
    }
    
    func getPaginatedLoadMoreCell(paginator: TableviewPaginatorEx) -> UITableViewCell {
        return UITableViewCell.init()
    }
    
    func getRefreshControlTintColor(paginator: TableviewPaginatorEx) -> UIColor {
          return UIColor.orange
    }
}

extension HomeViewController: TableviewPaginatorProtocol {
    func loadPaginatedData(offset: Int, shouldAppend: Bool, paginator: TableviewPaginatorEx) {
           print("LOAD")
    
        loadPlates()
        
     
    }
}
