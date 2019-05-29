//
//  UploadRecipeViewController.swift
//  Chefie
//
//  Created by Nicolae Luchian on 23/05/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import GoogleSignIn
import Kingfisher
import SkeletonView
import SDWebImage

class UploadRecipeViewController: UIViewController, DynamicViewControllerProto, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var tableItems: Array<BaseItemInfo> = []
    var tableCellRegistrator = TableCellRegistrator()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return comunidades[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return comunidades.count
    }
    
  

    
    
//    var tableItems = Array<BaseItemInfo>()
//    var tableCellRegistrator = TableCellRegistrator()
    
//    @IBOutlet var mainTable: UITableView!{
//        didSet {
//            mainTable.setCellsToAutomaticDimension()
//        }
//
//    }
    
    @IBOutlet var pickerView: UIPickerView!
    
    let comunidades = ["Andalucia","Aragon","Asturias","Baleares","Canarias","Cantabria","Castilla-La Mancha","Castilla y Leon","Catalunya","Extremadura","Galicia","La Rioja","Comunidad de Madrid","Murcia","Navarra","Pais Vasco","Comunidad Valenciana"]
    
//    override func viewWillAppear(_ animated: Bool) {
//        //self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
//        super.viewWillAppear(animated)
//        //mainTable.tableFooterView = UIView(frame: CGRectZero)
//        // Add a background view to the table view
//        let backgroundImage = UIImage(named: "huevos.jpg")
//        let imageView = UIImageView(image: backgroundImage)
//        self.mainTable.backgroundView = imageView
//    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
//        mainTable.snp.makeConstraints { (make) in
        
//            make.width.equalTo(self.view)
//            make.height.equalTo(self.view)
//        }
    }
    
    
    func onLoadData() {
        
//        let titleInfo = FieldValueData()
//        titleInfo.label = "Title"
//        titleInfo.value = ""
//
//        let plate = Plate()
//        plate.title = "Description: "
//        plate.description = " Write the description here: "
//
//
//        let item = UploadRecipeCellItemInfo()
//        let item2 = UploadDescriptionCellItemInfo()
//        item.model = titleInfo
//        item2.model = plate
//        tableItems.append(item)
//        tableItems.append(item2)
        
    }
    
    func onSetup() {
//        let cache = ImageCache.default
//        cache.clearMemoryCache()
//        cache.clearDiskCache()
//        SDImageCache.shared.clearMemory()
//        SDImageCache.shared.clearDisk()
    }
    
    func onSetupViews() {
//        mainTable.backgroundColor = UIColor.white
//        self.mainTable.dataSource = self
//        self.mainTable.delegate = self
//        self.mainTable.isSkeletonable = true
       
    }
    
    func onLayout() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Chefie"
        
        pickerView.delegate = self
        pickerView.dataSource = self
//
//        mainTable.allowsSelection = false
//        mainTable.backgroundColor = UIColor(white: 1, alpha: 0.5)
        
        self.navigationController!.navigationBar.isTranslucent = true
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Zapfino", size: 13)!]
        view.backgroundColor = .white
        onSetup()
        onSetupViews()
        
        
//        //Hay que cambiarlo por la celda que yo ponga despues.
//        tableCellRegistrator.add(identifier: UploadRecipeCellItemInfo().identifier(), cellClass: UploadRecipeInfoCellView.self)
//        
//        tableCellRegistrator.add(identifier: UploadDescriptionCellItemInfo().identifier(), cellClass: UploadDescriptionCellView.self)
//        
//        tableCellRegistrator.registerAll(tableView: mainTable)
        onLoadData()
    }
    

}
//
//extension UploadRecipeViewController: SkeletonTableViewDataSource, SkeletonTableViewDelegate {
//
////    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
////        cell.backgroundColor = UIColor(white: 1, alpha: 0.5)
////    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return tableItems.count
//    }
//
//    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
//        return tableItems [indexPath.row].identifier()
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        if (self.tableItems.count == 0){
//            let ce : BaseCell = mainTable.dequeueReusableCell(withIdentifier: tableCellRegistrator.getRandomIdentifier(), for: indexPath) as! BaseCell
//            ce.viewController = self
//            ce.parentView = tableView
//            return ce
//        }
//
//        let cellInfo = self.tableItems[indexPath.row]
//
//        let ce : BaseCell = mainTable.dequeueReusableCell(withIdentifier: cellInfo.identifier(), for: indexPath) as! BaseCell
//        ce.viewController = self
//        ce.parentView = tableView
//        ce.setModel(model: cellInfo.model)
//        ce.onLoadData()
//        return ce
//    }
//}
