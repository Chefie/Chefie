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
import JVFloatLabeledTextField
import Gallery
import FaveButton
import FirebaseFirestore
import CodableFirebase


class UploadRecipeViewController: UIViewController, UIPickerViewDataSource,UIPickerViewDelegate, UITextFieldDelegate,GalleryControllerDelegate, SkeletonTableViewDataSource, SkeletonTableViewDelegate,FaveButtonDelegate {
    
    
    var tableItems = Array<BaseItemInfo>()
    var tableCellRegistrator = TableCellRegistrator()
    let gallery = GalleryController()
    var timer = Timer()
    
    let comunidades = ["Andalucía", "Aragón", "Canarias", "Cantabria", "Castilla y León", "Castilla-La Mancha", "Cataluña", "Ceuta", "Comunidad Valenciana", "Comunidad de Madrid", "Extremadura", "Galicia", "Islas Baleares", "La Rioja", "Melilla", "Navarra", "País Vasco", "Principado de Asturias", "Región de Murcia"]

    //Outlets
    @IBOutlet weak var mainTable: UITableView!
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var titleTextField: SpringTextField!
    @IBOutlet var descriptionTextView: SpringTextView!
    @IBOutlet var hastagTextField: SpringTextField!
    @IBOutlet var tagListView: TagListView!
    @IBOutlet weak var btnDone: FaveButton!
    
    
    var contadorTags = 0
    
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
        
        let tags = tagListView.tagViews.compactMap { (tagView) -> Tag? in
            return Tag(label: tagView.titleLabel!.text!)
        }
        
        //Array de Media()
        var arrayMedia = [Media]()
        let mediaUno = Media()
        let mediaDos = Media()
        mediaUno.type = "image"
        mediaUno.id = "asdfghsafaafaajk"
        mediaUno.url = "https://i.kinja-img.com/gawker-media/image/upload/s--vHt6tbFa--/c_scale,f_auto,fl_progressive,q_80,w_800/xjmx1csashjww8j8jwyh.jpg"
        mediaDos.type = "image"
        mediaDos.id = "sdffgjknjbhvgcfg"
        mediaDos.url = "https://www.chewboom.com/wp-content/uploads/2018/06/McDonald’s-Is-Selling-A-New-Chinese-Szechuan-Burger-In-Canada-678x381.jpg"
        arrayMedia.append(mediaUno)
        arrayMedia.append(mediaDos)
        
        //Creacion del plato y sus atributos
        let plato = Plate()
        let comunidad = Community()
        comunidad.id = "comunidad001"
        comunidad.name = comunidadNombre
        comunidad.picture = "http://www.sclance.com/images/catalunya/Catalunya_184074.png"
        
        plato.id = "plato001"
        plato.idUser = appContainer.dataManager.localData?.chefieUser?.id
        plato.created_at = Date().convertDateToString()
        plato.title = titlePlate
        plato.tags = tags
        plato.multimedia = arrayMedia
        plato.numVisits = 23
        plato.description = description
        plato.community = comunidad
        
        
        if(titleTextField.text != "" && descriptionTextView.text != ""){
        uploadRecipe(plate: plato)
        }
//        sleep(1)
//        let vc = LoginViewController() //change this to your class name
//        self.present(vc, animated: true, completion: nil)
    }
    
    //Metodo que hace el insert de un plato en la BBDD.
    func uploadRecipe(plate: Plate) {
        let platesRef = Firestore.firestore().collection("Platos")
        
        do {
            
            let model = try FirestoreEncoder().encode(plate)
            platesRef.addDocument(data: model) { (err) in
                if err != nil {
                    print("---> Algo ha ido mal.")
                } else {
                    print("---> Plato subido con exito.")
                    //print("Model: \(model)")
                }
            }
            
        } catch  {
            print("Invalid Selection.")
        }
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Checking every second if texfields are not empty.
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(checkIfDone), userInfo: nil, repeats: true)
        
        btnDone.isHidden = true
        
        navigationItem.title = "New recipe"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Media", style: .plain, target: self, action: #selector(abrirGaleria))
        
        tableCellRegistrator.add(identifier: PlateMediaHorizontalBaseInfo().reuseIdentifier(), cellClass: PlateMediaHorizontalCell.self)
        self.navigationController!.navigationBar.isTranslucent = true
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Zapfino", size: 13)!]
        view.backgroundColor = .white
        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(close))
        
        //Delegates.
        gallery.delegate = self
        pickerView.delegate = self
        pickerView.dataSource = self
        titleTextField.delegate = self
        hastagTextField.delegate = self
        mainTable.delegate = self
        mainTable.dataSource = self
        
        //tagListView.addTags(["casero", "rico", "tortilla"])
        tagListView.alignment = .center
        tagListView.textFont = UIFont.systemFont(ofSize: 22)
        descriptionTextView.layer.borderWidth = 0.1;
        descriptionTextView.layer.cornerRadius = 5.0;
        
        //Main table settings.
        mainTable.translatesAutoresizingMaskIntoConstraints = false
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
        self.mainTable.isSkeletonable = true
        
        tableCellRegistrator.registerAll(tableView: mainTable)
        
        view.layoutIfNeeded()
        mainTable.layoutIfNeeded()
        loadData()
    }
    
    
    func faveButton(_ faveButton: FaveButton, didSelected selected: Bool) {
        
    }
    
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        
    }
    
   
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return comunidades[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return comunidades.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    //Metodo del slider-horizontal de Media
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        let mediaDataArray = images.compactMap { (image) -> MediaData in
            
            return MediaData(image: image)
        }
        
        let itemInfo = getModelById(id: PlateMediaHorizontalBaseInfo().uniqueIdentifier())
        itemInfo.model = mediaDataArray as AnyObject
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
    }
    
    func loadData() {
        
        
        let plateMediaHorizontalInfo = PlateMediaHorizontalBaseInfo()
        plateMediaHorizontalInfo.setTitle(value: "Media")
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

