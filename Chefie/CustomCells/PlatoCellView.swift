import Foundation
import UIKit
import Kingfisher
import SkeletonView
import SDWebImage
import AACarousel

class PlatoCellItemInfo : BaseItemInfo {
    
    override func reuseIdentifier() -> String {
        return "PlatoCellView"
    }
}

class PlatoCellView : BaseCell, ICellDataProtocol, INestedCell, AACarouselDelegate {
    var collectionItemSize: CGSize!

    typealias T = Plate
    
    var model: Plate?
   
    let frontImageView : UIImageView = {
        
        let img = UIImageView(maskConstraints: false)
        img.contentMode = ContentMode.scaleToFill
        return img
    }()
    
    let plateTitle : MultilineLabel = {
        let lbl = MultilineLabel(maskConstraints: false, font: DefaultFonts.DefaultTextFont)
        lbl.text = ""
        lbl.numberOfLines = 1
        //lbl.textColor = UIColor.white
        //lbl.backgroundColor = UIColor.blue
        return lbl
    }()
    
    let carousel : AACarousel = {
        
        let view = AACarousel(maskConstraints: false)
        return view
    }()
    
    override func setModel(model: AnyObject?) {
        self.model = (model as! Plate)
    }
    
    override func getModel() -> AnyObject? {
        return model
    }
    
    override func onLayout(size: CGSize!) {
        super.onLayout(size: size)
        
        if let size = self.cellSize {
            
            collectionItemSize = size
        }
        
        self.contentView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
            maker.left.top.right.bottom.equalTo(0)
            maker.width.equalTo(size.width)
            maker.height.equalTo(collectionItemSize.height)
        }
        
//        frontImageView.snp.makeConstraints { (maker) in
//
//            maker.width.equalTo(collectionItemSize.width.minus(amount: 10))
//            maker.height.equalTo(collectionItemSize.heightPercentageOf(amount: 88))
//            maker.topMargin.equalTo(0)
//            maker.bottomMargin.equalTo(10)
//            maker.left.equalTo(collectionItemSize.widthPercentageOf(amount: 5))
//            //      maker.centerX.equalTo(contentView)
//        }
//
        carousel.snp.makeConstraints { (maker) in
            
            maker.width.equalTo(collectionItemSize.width.minus(amount: 10))
            maker.height.equalTo(collectionItemSize.heightPercentageOf(amount: 88))
            maker.topMargin.equalTo(0)
            maker.bottomMargin.equalTo(10)
            maker.left.equalTo(collectionItemSize.widthPercentageOf(amount: 5))
            //      maker.centerX.equalTo(contentView)
        }
  
        self.plateTitle.snp.makeConstraints { (maker) in
            
            maker.width.equalTo(collectionItemSize.width.minus(amount: 20))
            maker.height.equalTo(collectionItemSize.heightPercentageOf(amount: 10))
            maker.bottomMargin.equalToSuperview().offset(4)
            maker.centerX.equalToSuperview()
        }
        
        carousel.setCarouselOpaque(layer: true, describedTitle: true, pageIndicator: false)
        
        self.carousel.setCornerRadius(radius: 8)
        
        plateTitle.displayLines(height: collectionItemSize.heightPercentageOf(amount: 10))
        
        // self.backgroundColor = UIColor.purple
        //self.backgroundColor = UIColor.red
        contentView.showAnimatedGradientSkeleton()
    }
    
    override func onLoadData() {
        
        carousel.delegate = self

        let arrayStr = model?.multimedia?.map({ (media) -> String in
            return media.url ?? ""
        })

        carousel.setCarouselData(paths: arrayStr!,  describedTitle: [""], isAutoScroll: true, timer: 5.0, defaultImage: "placeholder")

        self.carousel.doFadeIn()
        
      //  carousel.setCarouselLayout(displayStyle: 0, pageIndicatorPositon: 0, pageIndicatorColor: nil, describedTitleColor: nil, layerColor: nil)
      //  self.frontImageView.setTouch(target: self, selector: #selector(onTouch))
//        self.frontImageView.sd_setImage(with: URL(string: model?.multimedia?[0].url ?? "")){ (image : UIImage?,
//            error : Error?, cacheType : SDImageCacheType, url : URL?) in
//
//            self.hideSkeleton()
//
//            self.plateTitle.text = self.model?.title
//            self.plateTitle.hideLines()
//
//            self.doFadeIn()
//            // self.frontImageView.forceAddShadow(radius: 8)
//        }
    }
    
    func didSelectCarouselView(_ view: AACarousel, _ index: Int) {
        
    }
    
    func callBackFirstDisplayView(_ imageView: UIImageView, _ url: [String], _ index: Int) {
        
    }
    
    func downloadImages(_ url: String, _ index: Int) {
        
        let url = URL(string: url)
        
        SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { (image : UIImage?, data : Data?, error : Error?, cache : SDImageCacheType, result : Bool, url : URL?) in
            
            if let data = image {
                self.carousel.images[index] = data
            }
            
            self.hideSkeleton()
        }
    }
    
    @objc func onTouch() {
        
        let storyboard = UIStoryboard(name: "PlateDetailStoryboard", bundle: nil)
        let vc  : PlateDetailsViewController = storyboard.instantiateViewController(withIdentifier: "PlateDetailViewController") as! PlateDetailsViewController
        
        vc.model = model
        
        self.viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func onCreateViews() {
        super.onCreateViews()
        
        collectionItemSize = CGSize(width: 0, height: 0)
        self.contentView.addSubview(carousel)
        //self.contentView.addSubview(frontImageView)
        self.contentView.addSubview(plateTitle)
    }
}
