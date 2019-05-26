//
//  FoodTimelineViewController.swift
//  Chefie
//
//  Created by Steven on 27/04/2019.
//  Copyright © 2019 chefie. All rights reserved.
//
import Foundation
import UIKit
import Kingfisher
import SkeletonView
import SDWebImage

class PlateDetailsViewController : UIViewController, DynamicViewControllerProto {
    
    var model : Plate?{
        
        didSet{
         
        }
    }
    
    @IBOutlet weak var mainScrollContainer: UIScrollView!
    @IBOutlet weak var container: UIView!
    
    let frontPlateV : UIImageView = {
        
        let img = UIImageView(frame: CGRect())
        img.isSkeletonable = true
        img.setRounded()
      
        return img
    }()

    let titleLabel : UILabel = {
        let lbl = UILabel(frame: CGRect())
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .center
        lbl.textColor = .black
        lbl.text = "Plate Detail"
        lbl.isSkeletonable = true
        lbl.frame = CGRect(x: 0, y: 0, width: 500, height: 200)
       
        return lbl
    }()
    
    let infoView : InfoView = {
        let view = InfoView()
        return view
    }()
    
    let morePlatesView : ShowMoreHolderView = { () -> ShowMoreHolderView<Media> in
        let view = ShowMoreHolderView<Media>(frame: CGRect(), cellIdentifier: "MultimediaCell")
        return view
    }()
    
    func onLoadData() {
        
        infoView.lblTitle.text = model?.title

        morePlatesView.data = model?.multimedia
        morePlatesView.reloadCells()
        
        guard let date = model?.created_at?.parseToDate() else { return }

        infoView.lblDate.text  = model?.created_at?.extractInfoFromDate(date: date)
    }
    
    func onSetup() {
        
    }
    
    func onSetupViews() {
        
        stackView.addArrangedSubview(frontPlateV)
        stackView.addArrangedSubview(infoView)
        stackView.addArrangedSubview(morePlatesView)
        
        morePlatesView.tableView.register(MultimediaCell.self, forCellReuseIdentifier: "MultimediaCell")
        
        morePlatesView.lblTitle.text = "Multimedia"
        morePlatesView.onRequestCell = { (cellIdentifier, tableView, indexPath, data, dataLength) -> UITableViewCell in
        
            
             guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MultimediaCell
                
                else {
                    
                return UITableViewCell()
                
            }

            if (dataLength == 0){
                return cell
            }
            
            let dataModel = data as? Media
            
            if dataModel != nil {
                
                if cell is MultimediaCell {
                    cell.parentView = tableView
                    
                    cell.model = dataModel
                    
                 
                }
              
            }
            
            print(dataModel)
            
               return cell
        }
    }
    
    @IBOutlet weak var stackView: UIStackView!
    func onLayout() {
        
        //navigationController?.navigationBar.isHidden = true
        
        //frontPlateV.contentMode = ContentMode.scaleToFill
        
        let barTopMargin = navigationController?.navigationBar.getHeight() ?? view.heightPercentageOf(amount: 10)
  
     
   
        stackView.translatesAutoresizingMaskIntoConstraints = false;
        stackView.spacing = 10
//frontPlateV.image = UIImage(named: "AppIcon")
       

        mainScrollContainer.addSubview(stackView)
    
        stackView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        infoView.frame = CGRect(x: 0, y: 0, width: view.getWidth(), height: view.heightPercentageOf(amount: 10))
        
        morePlatesView.frame = CGRect(x: 0, y: 0, width: view.getWidth(), height: view.heightPercentageOf(amount: 80))
        
        infoView.doLayout()
        morePlatesView.doLayout()
        
        titleLabel.linesCornerRadius = gLabelRadius
        
        mainScrollContainer.contentSize = CGSize(width: 0, height: self.view.getHeight() + self.view.getHeight().percentageOf(amount: 50))
        stackView.showAnimatedGradientSkeleton()
    }
    
    override func viewDidLoad() {
         super.viewDidLoad()
        onSetupViews()
        onLayout()
       
        onLoadData()
        
        self.frontPlateV.sd_setImage(with: URL(string: model?.multimedia?[0].url ?? "")){ (image : UIImage?,
            error : Error?, cacheType : SDImageCacheType, url : URL?) in
            
             self.stackView.hideSkeleton()
        }
    
    }
}
