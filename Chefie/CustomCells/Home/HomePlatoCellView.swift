import Foundation
import UIKit
import SkeletonView
import SDWebImage
import FSPagerView

class HomePlatoCellItemInfo : BaseItemInfo {
    
    override func reuseIdentifier() -> String {
        return "HomePlatoCellView"
    }
}

class HomePlatoCellView : BaseCell, ICellDataProtocol,  FSPagerViewDataSource,FSPagerViewDelegate {

    typealias T = Plate
    
    var model: Plate?

    var collectionItemSize: CGSize!

    let carousel : FSPagerView = {
        
        let view = FSPagerView(maskConstraints: false)
        return view
    }()
    
    var multimedia = [Media]()
    
    let frontImageView : UIImageView = {
        
        let img = UIImageView(maskConstraints: false)
        img.contentMode = ContentMode.scaleToFill
        return img
    }()
    
    let plateTitle : MultilineLabel = {
        let lbl = MultilineLabel(maskConstraints: false, font: DefaultFonts.DefaultTextFont)
        lbl.text = ""
        lbl.numberOfLines = 1
        return lbl
    }()
    
    var isLiked = false
    
    let heartIcon : UIImageView = {
        let img = UIImageView(maskConstraints: false)
        img.contentMode = .scaleAspectFill
        img.image = UIImage(named: "NotLikedButton")
        img.hide()
        return img
    }()
    
    let shareIcon : UIImageView = {
        let img = UIImageView(maskConstraints: false)
        img.contentMode = ContentMode.scaleToFill
        img.frame = CGRect(x: 0, y: 0, width: 40, height: 0)
        img.layer.borderWidth = 1
        img.layer.borderColor = UIColor.black.cgColor
        img.layer.cornerRadius = img.frame.size.width / 2;
        img.clipsToBounds = true
        img.image = UIImage(named: "user")
        return img
    }()
    
    let profilePicIcon : UIImageView = {
        let img = UIImageView(maskConstraints: false)
        img.contentMode = ContentMode.scaleToFill
        img.frame = CGRect(x: 0, y: 0, width: 27, height: 0)
        img.layer.borderColor = UIColor.black.cgColor
        img.layer.cornerRadius = img.frame.size.width / 2;
        img.clipsToBounds = true
        img.image = UIImage(named: "user")
        return img
    }()
    
    let labelMonth : UILabel = {
        let lbl = UILabel(maskConstraints: false, font: DefaultFonts.DefaultTextBoldFont)
        lbl.text = "FEB"
        lbl.textAlignment = .center
        lbl.textColor = Palette.TextDefaultColor
        return lbl
    }()
    
    let labelDay : UILabel = {
        let lbl = UILabel(maskConstraints: false, font: DefaultFonts.DefaultTextLightFont)
        lbl.text = "03"
        lbl.textAlignment = .center
        lbl.textColor = .black
        return lbl
    }()
    
    let labelPlateTitle : MultilineLabel = {
        let lbl = MultilineLabel(maskConstraints: false, font: DefaultFonts.DefaultHeaderTextFont)
        lbl.text = "PAELLA DE MARISCO CON MUCHAS COSAS"
        lbl.numberOfLines = 0
        lbl.textAlignment = .left
        return lbl
    }()
    
    let labelUsername : MultilineLabel = {
        let lbl = MultilineLabel(maskConstraints: false, font: DefaultFonts.DefaultTextLightFont)
        lbl.text = "@joseantonio"
        lbl.numberOfLines = 0
        lbl.textAlignment = .left
        return lbl
    }()

    let labelNumLikes : PaddingLabel = {
        let lbl = PaddingLabel(maskConstraints: false, font: DefaultFonts.DefaultTextLightFont)
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = DefaultFonts.DefaultTextFont.withSize(12)
        lbl.isHidden = true
        return lbl
    }()
    
    let labelAgo: PaddingLabel = {
        let lbl = PaddingLabel(maskConstraints: false, font: DefaultFonts.DefaultTextLightFont)
        lbl.numberOfLines = 1
        lbl.textAlignment = .right
        lbl.font = DefaultFonts.DefaultTextFont.withSize(11)
        return lbl
    }()
    
    override func getSize() -> CGSize {
        return CGSize(width: parentView.getWidth(), height: parentView.heightPercentageOf(amount: 38))
    }
    
    override func setModel(model: AnyObject?) {
        self.model = (model as! Plate)
    }
    
    override func getModel() -> AnyObject? {
        return model
    }
    
    var mediaSection : CGRect = {
        
        let rect = CGRect(x: 0, y: 0, width: 0, height: 0)
        return rect
    }()
    
    var bottomSection : CGRect = {
        
        let rect = CGRect(x: 0, y: 0, width: 0, height: 0)
        return rect
    }()
    
    var sectionView : UIView = {
        
        let view = UIView(maskConstraints: false)
        return view
    }()
    
    override func onLayout(size: CGSize!) {
        super.onLayout(size: size)
        
        collectionItemSize = getSize()
        
        self.contentView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
            maker.left.top.right.bottom.equalTo(0)
            maker.width.equalTo(size.width)
            maker.height.equalTo(collectionItemSize.height)
        }
        
        mediaSection = CGRect(x: 0, y: 0, width: size.width.percentageOf(amount: 95), height: collectionItemSize.heightPercentageOf(amount: 75))
        bottomSection = CGRect(x: 0, y: mediaSection.height, width: size.width, height: collectionItemSize.heightPercentageOf(amount: 25))
        
        carousel.frame = CGRect(x: 0, y: 0, width: mediaSection.width, height: mediaSection.height)
        
        carousel.snp.makeConstraints { (maker) in

            maker.top.equalTo(0)
            maker.size.equalTo(mediaSection.size)
            maker.width.equalTo(mediaSection.width)
            maker.bottomMargin.equalTo(10)
            maker.left.equalTo(collectionItemSize.widthPercentageOf(amount: 2.5))
            maker.centerX.equalTo(contentView)
        }
        carousel.setCornerRadius()
        
        let labelHeight = mediaSection.height.percentageOf(amount: 10)
        
        let marginLeft = CGFloat(20)
        let marginTop = CGFloat(bottomSection.height.percentageOf(amount: 20))
        
        let userSize = CGSize(width:  bottomSection.width.percentageOf(amount: 6), height:  bottomSection.width.percentageOf(amount: 6))
  
        self.labelUsername.snp.makeConstraints { (maker) in
            maker.left.equalTo(marginLeft * 3)
            maker.width.equalTo(mediaSection.width.percentageOf(amount: 60).minus(amount: marginLeft))
            maker.height.equalTo(bottomSection.height.percentageOf(amount: 20))
            maker.top.equalTo(mediaSection.maxY + 4)
        }
        
        self.labelPlateTitle.snp.makeConstraints { (maker) in
            maker.left.equalTo(marginLeft * 3)
            maker.width.equalTo(mediaSection.width.percentageOf(amount: 80))
            maker.height.equalTo(bottomSection.height.percentageOf(amount: 60))
            maker.top.equalTo(mediaSection.maxY + marginTop + 5)
        }
        
        self.profilePicIcon.snp.makeConstraints { (maker) in
            maker.left.equalTo(marginLeft)
            maker.size.equalTo(userSize)
            maker.top.equalTo(mediaSection.maxY + 4)
        }
        
        self.labelMonth.snp.makeConstraints { (maker) in
            
            maker.left.equalTo(marginLeft)
            maker.height.equalTo(labelHeight)
            maker.top.equalTo(mediaSection.maxY + marginTop + userSize.height.percentageOf(amount: 50) + 6)
            //maker.bottom.equalTo(labelHeight * 2)
        }
        
        self.labelDay.snp.makeConstraints { (maker) in
            maker.left.equalTo(marginLeft + 4)
            maker.height.equalTo(labelHeight)
            maker.top.equalTo(mediaSection.maxY + marginTop + userSize.height + 12)
            //  maker.bottom.equalTo(labelHeight)
        }
        
     //   labelNumLikes.backgroundColor = UIColor.red

        let heartSize = CGSize(width: size.widthPercentageOf(amount: 16), height: size.widthPercentageOf(amount: 16))
        self.heartIcon.snp.makeConstraints { (maker) in
            
            maker.left.equalTo(size.widthPercentageOf(amount: 65))
            maker.size.equalTo(heartSize)
            maker.top.equalTo(mediaSection.maxY - (heartSize.height))
            //    maker.height.equalTo(labelHeight)
        }
        
        self.labelNumLikes.snp.makeConstraints { (maker) in
            
            maker.left.equalTo(size.widthPercentageOf(amount: 65))
          //  maker.height.equalTo(labelHeight)
            maker.top.equalTo(mediaSection.maxY)
        //    maker.height.equalTo(labelHeight)
        }
        
        self.labelAgo.snp.makeConstraints { (maker) in
            
            maker.left.equalTo(size.widthPercentageOf(amount: 65) + heartSize.width + marginLeft)
            //  maker.height.equalTo(labelHeight)
            maker.top.equalTo(mediaSection.maxY - marginTop + 8)
            //    maker.height.equalTo(labelHeight)
        }
        
       // labelNumLikes.textColor = UIColor.white
    
     //   labelNumLikes.setCornerRadius(radius: 4)
       // labelNumLikes.text = "120"
        
        plateTitle.displayLines(height: collectionItemSize.heightPercentageOf(amount: 10))
        
        let transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        self.carousel.itemSize = self.carousel.frame.size.applying(transform)
        self.carousel.decelerationDistance = 1
        
        sectionView.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.top.equalTo(bottomSection.minY)
            maker.width.equalTo(bottomSection.width)
            maker.height.equalTo(bottomSection.height)
        }
        
        self.profilePicIcon.showAnimatedGradientSkeleton()
    
        self.carousel.showAnimatedGradientSkeleton()
        
        self.labelPlateTitle.showAnimatedGradientSkeleton()
        self.labelUsername.showAnimatedGradientSkeleton()
        
        self.labelDay.showAnimatedGradientSkeleton()
        self.labelMonth.showAnimatedGradientSkeleton()
        
        self.profilePicIcon.showAnimatedGradientSkeleton()
        self.labelNumLikes.showAnimatedGradientSkeleton()
        
        self.labelAgo.showAnimatedGradientSkeleton()
    }

    override func onLoadData() {
        super.onLoadData()
        
        if let mediaList = model?.multimedia {
            
            multimedia.removeAll()
            multimedia.append(contentsOf: mediaList)
        }
        
        self.labelPlateTitle.text = model?.title
        
        if let user = model?.user{
            
            self.labelUsername.text = "@" + user.userName! 
        }
    
        self.heartIcon.show()
        self.labelNumLikes.text = "120 Likes"
        
        if let picUrl = model?.user?.profilePic {

            self.profilePicIcon.sd_setImage(with: URL(string: picUrl)){ (image : UIImage?,
                error : Error?, cacheType : SDImageCacheType, url : URL?) in
                
                self.profilePicIcon.hideSkeleton()
            }
        }
 
        self.labelNumLikes.show()
        
        if let date = model?.created_at {
            
            let parsedDate = date.parseToDate()
            
            if let dayNumber = parsedDate.dayNumberOfWeek() {
                self.labelDay.text = String(describing: dayNumber)
            }

            self.labelMonth.text = parsedDate.monthNameLocalized()?.capitalized
            
            self.labelAgo.text = parsedDate.timeAgoDisplay()
        }
        
        carousel.reloadData()
     
        self.hideSkeleton()
    }
    
    func doToggleLike() {
        
        if (!self.isLiked){
            
            self.heartIcon.image = UIImage(named: "LikeButton")
            self.isLiked = true
        }
        else {
            
            self.heartIcon.image = UIImage(named: "NotLikedButton")
            self.isLiked = false
        }
    }
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return multimedia.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        let mediaInfo = multimedia[index]
    
        cell.contentView.setCornerRadius(radius: 4)
        cell.contentView.addShadow(radius: 6)
        if mediaInfo.type == ContentType.VideoMP4.rawValue {
            
            cell.imageView?.sd_setImage(with: URL(string: mediaInfo.thumbnail ?? "")){ (image : UIImage?,
                error : Error?, cacheType : SDImageCacheType, url : URL?) in
                
                let image = image?.drawDarkRect().with(image: "play_video", rectCalculation: { (parentSize, newSize) -> (CGRect) in
                    return CGRect(x: 0, y: 0, width: 90, height: 90)
                })
                cell.imageView?.image = image
            }
        }
        else {
            
            cell.imageView?.sd_setImage(with: URL(string: mediaInfo.url ?? "")){ (image : UIImage?,
                error : Error?, cacheType : SDImageCacheType, url : URL?) in
                
            }
        }
        
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        return cell
    }
    
    @objc func onTouch() {
        
        if model != nil {
            let storyboard = UIStoryboard(name: "PlateDetailStoryboard", bundle: nil)
            let vc  : PlateDetailsViewController = storyboard.instantiateViewController(withIdentifier: "PlateDetailViewController") as! PlateDetailsViewController

            vc.model = model
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func onLike() {
        
        doToggleLike()
    }
    
    @objc func onGoToProfile() {
        
        let storyboard = UIStoryboard(name: "ForeignProfileStoryboard", bundle: nil)
        let vc  : ForeignProfileViewController = storyboard.instantiateViewController(withIdentifier: "ForeignProfileViewController") as! ForeignProfileViewController
        
        vc.model = model?.user
        self.viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func onCreateViews() {
        super.onCreateViews()
   
        self.contentView.addSubview(sectionView)
        self.contentView.addSubview(labelPlateTitle)
        self.contentView.addSubview(carousel)
        self.contentView.addSubview(labelMonth)
        self.contentView.addSubview(labelDay)
        self.contentView.addSubview(labelUsername)
        self.contentView.addSubview(profilePicIcon)
        self.contentView.addSubview(heartIcon)
        self.contentView.addSubview(labelNumLikes)
        self.contentView.addSubview(labelAgo)
        self.carousel.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        self.carousel.itemSize = FSPagerView.automaticSize
        self.carousel.transformer = FSPagerViewTransformer(type:.coverFlow)
        
        carousel.delegate = self
        carousel.dataSource = self
        
        self.contentView.setTouch(target: self, selector: #selector(onTouch))
        self.profilePicIcon.setTouch(target: self, selector: #selector(onGoToProfile))
        self.heartIcon.setTouch(target: self, selector: #selector(onLike))
    }
}

