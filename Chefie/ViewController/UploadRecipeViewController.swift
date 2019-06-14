//
//  UploadRecipeViewController.swift
//  Chefie
//
//  Created by Nicolae Luchian on 28/05/2019.
//  Copyright © 2019 chefie. All rights reserved.
//
import Foundation
import UIKit
import Firebase
import GoogleSignIn
import SkeletonView
import SDWebImage
import TagListView
import Gallery
import FaveButton
import FirebaseFirestore
import CodableFirebase
import Photos
import SCLAlertView

class UploadRecipeViewController: UIViewController, UIPickerViewDataSource,UIPickerViewDelegate, UITextFieldDelegate,GalleryControllerDelegate, SkeletonTableViewDataSource, SkeletonTableViewDelegate,FaveButtonDelegate {
    
    var tableItems = Array<BaseItemInfo>()
    var tableCellRegistrator = TableCellRegistrator()
    let gallery = GalleryController()
    var timer = Timer()
    
    var comunidades = [Community]()
    
    //Outlets
    @IBOutlet weak var mainTable: UITableView!
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var titleTextField: SpringTextField!
    @IBOutlet var descriptionTextView: SpringTextView!
    @IBOutlet var hastagTextField: SpringTextField!
    @IBOutlet var tagListView: TagListView!
    @IBOutlet weak var btnDone: FaveButton!
    
    var images = [Image]()
    var imagesData = [Data]()
    var contadorTags = 0
    var videos = [Video]()
    
    var didSendUpload = false
    
    //Abre la galeria
    @objc func abrirGaleria() {
        
        present(gallery, animated: true, completion: nil)
    }
    
    //Metodo de subir plato al Firestore
    @IBAction func subirPlato(_ sender: Any) {
        timer.invalidate()
        
        let numeroComunidad = pickerView.selectedRow(inComponent: 0)
        let titlePlate = titleTextField.text!
        let description = descriptionTextView.text!
        let comunidadNombre = comunidades[numeroComunidad]
        
        var tags = [String:Bool]()
        tagListView.tagViews.forEach { (tagView) in
            
            tags[tagView.titleLabel!.text!] = true
        }
        let plato = Plate()
        plato.created_at = Date().convertDateToString()
        plato.community = comunidadNombre
        plato.idUser = appContainer.dataManager.localData.chefieUser.id
        plato.title = titlePlate
        plato.tags = tags
        plato.user = appContainer.dataManager.localData.chefieUser.mapToUserMin()
        plato.multimedia = Array<Media>()
        plato.numVisits = 0
        plato.description = description
        
        uploadRecipe(plate: plato)
    }
    
    func saveToFireBase(plate : Plate) {
        
        if (images.isEmpty && videos.isEmpty){
            self.createPlateEntry(plate: plate)
        }
    }
    
    var uploadingResponder : SCLAlertViewResponder!
    
    //Metodo que hace el insert de un plato en la BBDD.
    func uploadRecipe(plate: Plate) {
        
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let uploadingAlertView = SCLAlertView(appearance: appearance)
        uploadingResponder = uploadingAlertView.showNotice("Uploading Recipe...", subTitle: "")
        
        if (!images.isEmpty){
            Image.resolve(images: self.images, completion: { [weak self] resolvedImages in
                
                let imageDataArray = resolvedImages.compactMap({ (image) -> Data? in
                    return image?.rawData()
                })
                
                appContainer.s3Repository.uploadImageBatch(dataArray: imageDataArray ) { (
                    result : Result<S3MediaUploadBatchResult, Error>) in
                    
                    switch result {
                    case .success(let data):
                        
                        let urlArray = data.result.compactMap({ (item) -> Media? in
                            let media = Media()
                            media.id = item.id
                            media.url = item.url
                            media.type = item.contentType
                            return media
                        })
                        
                        plate.multimedia?.append(contentsOf: urlArray)
                        print("Uploaded photos")
                        
                        break
                    case .failure( _):
                        
                        break
                    }
                    
                    self?.images.removeAll()
                    
                    self?.saveToFireBase(plate: plate)
                }
            })
        }
        
        if (!videos.isEmpty){
            
            getDataFromVideos(videos: self.videos) { (result : ChefieResult<[GetVideoDataResult]>) in
                
                switch result {
                    
                case .success(let data):
                    
                    appContainer.s3Repository.uploadVideoBatch(dataArray: data, completionHandler: { (result : Result<S3MediaUploadBatchResult, Error>) in
                        
                        switch result {
                            
                        case .success(let result):
                            let urlArray = result.result.compactMap({ (item) -> Media? in
                                let media = Media()
                                media.id = item.id
                                media.url = item.url
                                media.thumbnail = item.thumbnailUrl
                                media.type = item.contentType
                                return media
                            })
                            
                            plate.multimedia?.append(contentsOf: urlArray)
                            
                            break
                        case .failure(_) :
                            
                            print("")
                            
                            break
                        }
                        
                        self.videos.removeAll()
                        self.saveToFireBase(plate: plate)
                        
                        print("Uploaded videos")
                        
                    })
                    break
                case .failure(_) :
                    self.videos.removeAll()
                    break
                }
            }
        }
    }
    
    func getDataFromVideos(videos : [Video], completionHandler: @escaping (ChefieResult<[GetVideoDataResult]>) -> Void ) {
        
        var outputData = [GetVideoDataResult]()
        let dispatchQueue = DispatchQueue(label: "GetDataFromVideos", qos: .background)
        dispatchQueue.async{
            
            var batchCount = max(videos.count - 1, 0)
            var running = false, finished = false
            while(!finished) {
                
                if (!running && !finished){
                    
                    if (batchCount < 0){
                        finished = true
                        continue
                    }
                    
                    running = true
                    
                    let asset = videos [batchCount].asset
                    
                    PHImageManager.default().requestAVAsset(forVideo: asset, options: nil, resultHandler: { (asset, mix, nil) in
                        let myAsset = asset as? AVURLAsset
                        do {
                            let videoData = try Data(contentsOf: (myAsset?.url)!)
                            
                            if (batchCount >= 0){
                                videos[batchCount].fetchThumbnail(size: CGSize(width: 300, height: 280), completion: { (image : UIImage?) in
                                    
                                    if image != nil {
                                        
                                        let videoThumb = image?.drawDarkRect().with(image: "play_video", rectCalculation: { (parentSize, newSize) -> (CGRect) in
                                            return CGRect(x: 300 / 2 - 60, y: 280 / 2 - 60, width: 60, height: 60)
                                        })
                                        let data = videoThumb!.rawData()
                                        
                                        let result = GetVideoDataResult(thumbnailData: data, videoData: videoData)
                                        
                                        outputData.append(result)
                                        
                                    }
                                    
                                    batchCount -= 1
                                    
                                    running = false
                                })
                            }
                            
                            print("video data : \(videoData)")
                        } catch  {
                            print("exception when getting data from video")
                        }
                    })
                }
            }
            
            completionHandler(.success(outputData))
        }
    }
    
    func createPlateEntry(plate : Plate) {
        appContainer.plateRepository.uploadRecipe(plate: plate) { (result : ChefieResult<UploadRecipeResult>) in
            
            switch result {
                
            case .success(let result):
                
                self.uploadingResponder.close()
                if !result.succeded {
                    
                    let appearance = SCLAlertView.SCLAppearance(
                        showCloseButton: false
                    )
                    let alertView = SCLAlertView(appearance: appearance)
                    alertView.addButton("Done") {
                        self.dismiss(animated: true, completion: {
                            
                        })
                    }
                    
                    alertView.showError("Failed to upload Recipe", subTitle: "The recipe couldn't be uploaded").setDismissBlock {
                        self.dismiss(animated: true, completion: {
                            
                        })
                    }
                    print("---> Algo ha ido mal.")
                } else {
                    // Don't need to wait for this
                    appContainer.feedRepository.sendFeedToFollowers(idUser: appContainer.getUser().id!, plate: plate, timeStamp: result.timeStamp)
                    
                    appContainer.feedRepository.sendFeedTo(id: appContainer.getUser().id!, timeStamp: result.timeStamp, data: plate, completionHandler: { (result) in
                        
                    })
                    
                    appContainer.dataManager.remoteData.onNewPlate(plate: plate)
                    print("---> Plato subido con exito.")
                    let appearance = SCLAlertView.SCLAppearance(
                        showCloseButton: false
                    )
                    let alertView = SCLAlertView(appearance: appearance)
                    alertView.addButton("Great!") {
                        self.dismiss(animated: true, completion: {
                            
                        })
                    }
                    
                    alertView.showSuccess("Recipe Uploaded", subTitle: "Your recipe has been successfully published").setDismissBlock {
                        
                        self.dismiss(animated: true, completion: {
                            
                        })
                    }
                }
                
                break
            case .failure(let err):
                
                // This must never happen
                print(err)
                break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setTintColor()
        
        mainTable.setDefaultSettings()
        mainTable.alwaysBounceVertical = false
        mainTable.isScrollEnabled = false
        
        //Checking every second if texfields are not empty.
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(checkIfDone), userInfo: nil, repeats: true)
        
        btnDone.isHidden = false
        
        navigationItem.title = "New Recipe"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Media", style: .plain, target: self, action: #selector(abrirGaleria))
        
        tableCellRegistrator.add(identifier: PlateMediaHorizontalBaseInfo().reuseIdentifier(), cellClass: PlateMediaHorizontalCell.self)
        self.navigationController!.navigationBar.isTranslucent = true
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Zapfino", size: 13)!]
        view.backgroundColor = .white
        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "<", style: .plain, target: self, action: #selector(close))
        
        //Delegates.
        gallery.delegate = self
        pickerView.delegate = self
        pickerView.dataSource = self
        titleTextField.delegate = self
        hastagTextField.delegate = self
        mainTable.delegate = self
        mainTable.dataSource = self
        
        tagListView.alignment = .center
        tagListView.textFont = UIFont.systemFont(ofSize: 22)
        descriptionTextView.layer.borderWidth = 0.1;
        descriptionTextView.layer.cornerRadius = 5.0;
        
        //Main table settings.
        mainTable.setDefaultSettings()
        mainTable.setContentInset(top: 10)
        self.mainTable.isSkeletonable = true
        
        tableCellRegistrator.registerAll(tableView: mainTable)
        
        view.layoutIfNeeded()
        mainTable.layoutIfNeeded()
        loadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        return true
    }
    
    func faveButton(_ faveButton: FaveButton, didSelected selected: Bool) {
        
    }
    
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        
        videos.append(video)
        
        let mediaDataArray = videos.compactMap { (image) -> MultimediaData in
            
            return MultimediaData(video: video, image: nil, contentType: "video")
        }
        
        let itemInfo = getModelById(id: PlateMediaHorizontalBaseInfo().uniqueIdentifier())
        var model = itemInfo.model as! [MultimediaData]
        model.append(contentsOf: mediaDataArray)
        itemInfo.model = model as AnyObject
        
        self.mainTable.reloadData()
        gallery.dismiss(animated: true) {
            
        }
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        
        
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        
        gallery.dismiss(animated: true) {
            
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return comunidades[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return comunidades.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
    }
    
    //Metodo del slider-horizontal de Media
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        self.images.append(contentsOf: images)
        
        let mediaDataArray = images.compactMap { (image) -> MultimediaData in
            
            return MultimediaData(video: nil, image: image, contentType: "image")
        }
        
        let itemInfo = getModelById(id: PlateMediaHorizontalBaseInfo().uniqueIdentifier())
        var model = itemInfo.model as! [MultimediaData]
        model.append(contentsOf: mediaDataArray)
        itemInfo.model = model as AnyObject
        
        self.mainTable.reloadData()
        gallery.dismiss(animated: true) {
            
        }
    }
    
    func getModelById(id : String) -> BaseItemInfo {
        
        let model = tableItems.filter { (item) -> Bool in
            return id == item.uniqueIdentifier()
            }.first
        
        return model!
    }
    
    //Añade los tags a la vista de tags.
    @IBAction func addTagToList(_ button: Any) {
        
        if(hastagTextField.text != "" && hastagTextField.text!.count <= 10){
            contadorTags += 1
            if(contadorTags <= 7){
                tagListView.addTag(hastagTextField.text!)
            }
            
            hastagTextField.text = ""
        }
    }
    
    //Elimina todos los tags.
    @IBAction func removeAllTags(_ sender: Any) {
        tagListView.removeAllTags()
        contadorTags = 0
        
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
    }
    
    @objc func close() {
        
        self.dismiss(animated: true) {
            
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func loadData() {
        
        appContainer.communityRepository.getCommunities { (result : ChefieResult<[Community]>) in
            
            switch result {
                
            case .success(let data):
                
                self.comunidades.append(contentsOf: data)
                self.pickerView.reloadComponent(0)
                break
            case .failure(_): break
            }
        }
        
        let plateMediaHorizontalInfo = PlateMediaHorizontalBaseInfo()
        plateMediaHorizontalInfo.setTitle(value: "Media")
        plateMediaHorizontalInfo.model = Array<MultimediaData>() as AnyObject
        tableItems.append(plateMediaHorizontalInfo)
        //tableItems.append(plateMediaHorizontalInfo)
        
        self.mainTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
        
        print("")
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
    
    //Ocultar el keybord haciendo click en la pantalla.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func checkIfDone(){
        
        if(titleTextField.text != "" && descriptionTextView.text != ""){
            btnDone.isHidden = false
        }else{
            btnDone.isHidden = true
        }
    }
}


