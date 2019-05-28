import Foundation
import UIKit
import Firebase
import GoogleSignIn
import Kingfisher
import SkeletonView
import SDWebImage

let PlateCellIdentifier = "PlateCellView"

class HomeViewController: UIViewController, DynamicViewControllerProto {
  
    var tableItems = Array<BaseItemInfo>()
    var tableCellRegistrator = TableCellRegistrator()
    
    @IBOutlet weak var mainTable: UITableView!{
        didSet {
            
            mainTable.setCellsToAutomaticDimension()
            mainTable.separatorStyle = UITableViewCell.SeparatorStyle.none
            mainTable.allowsSelection = false
            mainTable.allowsMultipleSelection = false
            mainTable.showsHorizontalScrollIndicator = false
            mainTable.alwaysBounceHorizontal = false
            mainTable.alwaysBounceVertical = false
            mainTable.bounces = false
 
            mainTable.showsVerticalScrollIndicator = false
            mainTable.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
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
    }
    
    func onSetupViews(){
        
        mainTable.backgroundColor = UIColor.white
        
        mainTable.snp.makeConstraints { (make) in
            
        //    make.topMargin.equalTo(50)
            make.width.equalTo(self.view.getWidth())
            make.height.equalTo(self.view.getHeight())
        }
    }
    
    func onLoadData() {
        
    }
    
    func onLayout() {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
           tableCellRegistrator.add(identifier: CommentsHorizontalCellInfo().reuseIdentifier(), cellClass: CommentsHorizontalCell.self)
        tableCellRegistrator.add(identifier: PlatosVerticalCellBaseItemInfo().reuseIdentifier(), cellClass: PlatosVerticalCell.self)
        
        
    
        
        onSetup()
        onSetupViews()

     //tableCellRegistrator.add(identifier: PlatoCellItemInfo().reuseIdentifier(), cellClass: PlatoCellView.self)
       // tableCellRegistrator.add(identifier: CommentCellInfo().reuseIdentifier(), cellClass: CommentCell.self)
        
        
        
//        registeredCells.append( PlatoCellItemInfo().identifier(), MediaCellView.self)

        tableCellRegistrator.registerAll(tableView: mainTable)
        
        
        var comments = [String]()
        comments.append("Este es un comentario corto")
        comments.append("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.")
         comments.append("Five hours? Aw, man! Couldn't you just get me the death penalty?")
         comments.append("Five hours? Aw, man! Couldn't you just get me the death penalty?")
         comments.append("Five hours? Aw, man! Couldn't you just get me the death penalty?")
         comments.append("Five hours? Aw, man! Couldn't you just get me the death penalty?")
         comments.append("Vastness is bearable only through love take root and flourish radio telescope not a sunrise but a galaxyrise rings of Uranus a very small stage in a vast cosmic arena. Descended from astronomers Tunguska event the only home we've ever known two ghostly white figures in coveralls and helmets are soflty dancing realm of the galaxies across the centuries. Emerged into consciousness gathered by gravity two ghostly white figures in coveralls and helmets are soflty dancing concept of the number one the only home we've ever known dispassionate extraterrestrial observer and billions upon billions upon billions upon billions upon billions upon billions upon billions.")

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
        
        appContainer.plateRepository.getPlatos(idUser: "2WT9s7km17QdtIwpYlEZ") { (
            result: ChefieResult<[Plate]>) in
            
            switch result {
                
            case .success(let data):
            
                var items = [BaseItemInfo]()
          
                let verticalItemPlateInfo = PlatosVerticalCellBaseItemInfo()
                verticalItemPlateInfo.setTitle(value: "Plates")
                verticalItemPlateInfo.model = data as AnyObject
    
                var commentItems = [Comment]()
                comments.forEach({ (commentStr) in
                    
                    let comment = Comment()
                    comment.idUser = "Steven"
                    comment.content = commentStr
                    commentItems.append(comment)
                    let commentInfo = CommentCellInfo()
                    commentInfo.model = comment
        // items.append(commentInfo)
                })
                
                let commentsHorizontal = CommentsHorizontalCellInfo()
                commentsHorizontal.setTitle(value: "Comments")
                commentsHorizontal.model = commentItems as AnyObject
                
                self.tableItems.append(commentsHorizontal)
                
             self.tableItems.append(verticalItemPlateInfo)
              
                data.forEach({ (plate) in
 
                    let cellInfo = PlatoCellItemInfo()
                    cellInfo.model = plate
                
             //      items.append(cellInfo)
                })

            //    items.shuffle()
           // self.tableItems = items
                self.mainTable.reloadData()
                break
            case .failure(_):
                break
            }
        }
    }

    @IBAction func onTouchsss(_ sender: UIButton) {
    }
    @IBAction func btnTap(_ sender: Any) {
        
       let item = self.tableItems[1].model as? Comment
      item?.content = "La celda se debe adaptar al texto"
        
      mainTable.reloadRows(at: [IndexPath(item:1 , section: 0)], with: .none)
        print("")
    }
    
    @IBAction func testClick(_ sender: UIButton) {
        view.startSkeletonAnimation()
        view.showAnimatedGradientSkeleton()
    }
    
    //Log out button Chefie
    func logOutButtonAction(_ sender: Any) {
        
        view.startSkeletonAnimation()
        view.showAnimatedGradientSkeleton()
//        try! Auth.auth().signOut()
//        try! GIDSignIn.sharedInstance()?.signOut()
//
//        self.dismiss(animated: false, completion: nil)
//        self.performSegue(withIdentifier: "backToLogin", sender: self)
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
        return tableItems.count == 0 ? AppSettings.DefaultSkeletonCellCount : tableItems.count
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
