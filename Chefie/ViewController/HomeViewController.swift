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
        }
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        mainTable.snp.makeConstraints { (make) in
            
            make.width.equalTo(self.view)
            make.height.equalTo(self.view)
        }
    }
    
    func onSetup() {
        let cache = ImageCache.default
        cache.clearMemoryCache()
        cache.clearDiskCache()
        
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
    }
    
    func onSetupViews(){
        
        mainTable.backgroundColor = UIColor.white
    }
    
    func onLoadData() {
        
    }
    
    func onLayout() {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
       
        onSetup()
        onSetupViews()

       //mainTable.register(CommentCell.self, forCellReuseIdentifier: CommentCellInfo().identifier())
        
       //mainTable.register(PlatoCellView.self, forCellReuseIdentifier: PlatoCellItemInfo().identifier())
  
       tableCellRegistrator.add(identifier: PlatoCellItemInfo().identifier(), cellClass: PlatoCellView.self)
       tableCellRegistrator.add(identifier: CommentCellInfo().identifier(), cellClass: CommentCell.self)
//        registeredCells.append( PlatoCellItemInfo().identifier(), MediaCellView.self)

        tableCellRegistrator.registerAll(tableView: mainTable)
        
        
        var comments = [String]()
        comments.append("Este es un comentario corto")
        comments.append("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.")
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
        
        appContainer.plateRepository.getPlatos(idUser: "2WT9s7km17QdtIwpYlEZ") { (
            result: ChefieResult<[Plate]>) in
            
            switch result {
                
            case .success(let data):
            
                var items = [BaseItemInfo]()
                
                comments.forEach({ (commentStr) in
                    
                    let comment = Comment()
                    comment.idUser = "Steven"
                    comment.content = commentStr
                    
                    let commentInfo = CommentCellInfo()
                    commentInfo.model = comment
                    items.append(commentInfo)
                })
            
                data.forEach({ (plate) in
 
                    let cellInfo = PlatoCellItemInfo()
                    cellInfo.model = plate
                    items.append(cellInfo)
                })

                 items.shuffle()
                self.tableItems = items
                self.mainTable.reloadData()
                break
            case .failure(_):
                break
            }
        }
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
        return tableItems.count == 0 ? 4 : tableItems.count
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return tableItems [indexPath.row].identifier()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (self.tableItems.count == 0){
            let ce : BaseCell = mainTable.dequeueReusableCell(withIdentifier: tableCellRegistrator.getRandomIdentifier(), for: indexPath) as! BaseCell
            ce.viewController = self
            ce.parentView = tableView
            return ce
        }
        
        let cellInfo = self.tableItems[indexPath.row]
   
        let ce : BaseCell = mainTable.dequeueReusableCell(withIdentifier: cellInfo.identifier(), for: indexPath) as! BaseCell
        ce.viewController = self
        ce.parentView = tableView
        ce.setModel(model: cellInfo.model)
        ce.onLoadData()
        return ce
    }
}
