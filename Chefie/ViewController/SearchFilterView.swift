//
//  CustomAlertController.swift
//  Chefie
//
//  Created by Nicolae Luchian on 06/06/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import UIKit
import TagListView

class SearchFilter {
    
    var collection : String!
    var community: String!
    var name : String!
}

class SearchFilterView: UIView, UIPickerViewDelegate,UIPickerViewDataSource, TagListViewDelegate {
    
    var comunidades = [Community]()
    
    var valorComunidad : Community?
    var filter = SearchFilter()
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return comunidades.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let selected = pickerView.selectedRow(inComponent: 0)
        valorComunidad = comunidades[selected]
        return comunidades[row].name
    }
    
    func setup() {
        pickerView.delegate = self
        pickerView.dataSource = self
        tagList.delegate = self
        tagList.textFont = DefaultFonts.DefaultTextFont
        tagList.alignment = .left
        tagList.addTags([SearchQueryInfo.Plates.rawValue, SearchQueryInfo.Users.rawValue])
    }
    
    func setFilter(filter : SearchFilter){
        
        self.filter = filter
        let item = self.tagList.tagViews.filter { (tag) -> Bool in
            tag.titleLabel!.text == filter.collection
        }.first
        
        item?.isSelected = true
    }
    
    func loadData() {
        
        appContainer.communityRepository.getCommunities { (result : ChefieResult<[Community]>) in
            
            switch result {
                
            case .success(let data) :
                
                self.comunidades.removeAll()
                self.comunidades.append(contentsOf: data)
                self.pickerView.reloadAllComponents()
                
                self.onPickerViewLoaded()
                break
            case .failure(_): break
            }
        }
    }
    
    func onPickerViewLoaded() {
        
        let item = self.comunidades.firstIndex { (com) -> Bool in
            com.id == self.filter.community
        }
      
        self.pickerView.selectRow(item ?? 4, inComponent: 0, animated: true)
    }
    
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        
        tagList.tagViews.forEach { (tagView) in
            tagView.isSelected = false
        }
        
        tagView.isSelected = true
        
        filter.collection = title
    }
    
    func getFilter() -> SearchFilter {
        filter.name = comunidades[pickerView.selectedRow(inComponent: 0)].name
        filter.community = comunidades[pickerView.selectedRow(inComponent: 0)].id
        return filter
    }

    @IBOutlet var tagList: TagListView!
    @IBOutlet var labelCommunity: UILabel!
    @IBOutlet var pickerView: UIPickerView!
}
