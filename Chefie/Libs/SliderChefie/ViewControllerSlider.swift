//
//  ViewControllerSlider.swift
//  CustomTableViewCell_nicoLuchian
//
//  Created by Nicolae Luchian on 03/04/2019.
//  Copyright © 2019 Nicolae Luchian. All rights reserved.
//

import UIKit

class ViewControllerSlider: UIViewController, UIScrollViewDelegate {
    
    var slides:[Slide] = [];
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageController: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        //Cargo el array de slides.
        slides = createSlides()
        setupSlideScrollView(slides: slides)
        
        pageController.numberOfPages = slides.count
        pageController.currentPage = 0
        view.bringSubviewToFront(pageController)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //COMPRUEBO SI HAY ALGO EL LA KEY DE DEFAULTS, SI HAY LLEVAME AL MENU PRINCIPAL
        // Y YA NO DEBERIA SALIRME EL SLIDER
        if (UserDefaults.standard.object(forKey: "runed") != nil) {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginView")
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    //Method that goes to other View
    @objc func showVc(){
        
        //--- AL AMPEZAR GUARDO UN STRING EN EL USERDEFAULTS
        UserDefaults.standard.set("vamos", forKey: "runed")
        
        //AL CLICKAR EL BUTTON DEL SLIDER NOS LLEVA A LA PANTALLA DEL LOGIN
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginView")
        self.present(vc, animated: true, completion: nil)
    }
    
    //Me devuelve un array de Slides.
    func createSlides() -> [Slide] {
        
        let slide1:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide1.doggyimage.image = UIImage(named: "slide1")
        slide1.doggyDescription.text = "Bienvenido a Chefie"
        slide1.doggyDescription.font = UIFont(name: "Zapfino"
        , size: 26)
        slide1.btnClick.isHidden = true
        
        slide1.backgroundColor = UIColor(red: 0.8863, green: 0.6784, blue: 0.6039, alpha: 1.0)
        
        let slide2:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide2.doggyimage.image = UIImage(named: "slide2")
        slide2.doggyDescription.text = "Muestra tus recetas"
       
        slide2.btnClick.isHidden = true
        slide2.backgroundColor = UIColor(red: 0.8863, green: 0.6784, blue: 0.6039, alpha: 1.0)
        
        let slide3:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide3.doggyimage.image = UIImage(named: "slide3")
        slide3.doggyDescription.text = "Descubre nuevas recetas"
        
        slide3.btnClick.isHidden = true
        slide3.backgroundColor = UIColor(red: 0.8863, green: 0.6784, blue: 0.6039, alpha: 1.0)
        
        let slide4:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide4.doggyimage.image = UIImage(named: "slide4")
        slide4.doggyDescription.text = "Comparte ideas e inspirate"
       
        slide4.btnClick.isHidden = true
        slide4.backgroundColor = UIColor(red: 0.8863, green: 0.6784, blue: 0.6039, alpha: 1.0)
        
        
        let slide5:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide5.doggyimage.image = UIImage(named: "slide5")
        slide5.doggyDescription.text = "Crea chats con otros cocineros"
       
        
        
        //Showing the button in the last slide
        slide5.backgroundColor = UIColor(red: 0.8863, green: 0.6784, blue: 0.6039, alpha: 1.0)
        slide5.btnClick.isHidden = false
        
        //slide5.btnClick.layer.cornerRadius = 20
        //Adding target when button from Slider is clicked
        slide5.btnClick.addTarget(self, action: #selector(self.showVc), for: .touchUpInside)
        
        return [slide1, slide2, slide3, slide4, slide5]
    }
    func setupSlideScrollView(slides : [Slide]) {
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.addSubview(slides[i])
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageController.currentPage = Int(pageIndex)
        
        let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
        
        // vertical
        let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
        let currentVerticalOffset: CGFloat = scrollView.contentOffset.y
        
        let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
        let percentageVerticalOffset: CGFloat = currentVerticalOffset / maximumVerticalOffset
        
        
    
        
        /*
         * below code scales the imageview on paging the scrollview
         */
        let percentOffset: CGPoint = CGPoint(x: percentageHorizontalOffset, y: percentageVerticalOffset)
        
        if(percentOffset.x > 0 && percentOffset.x <= 0.25) {
            
            slides[0].doggyimage.transform = CGAffineTransform(scaleX: (0.25-percentOffset.x)/0.25, y: (0.25-percentOffset.x)/0.25)
            slides[1].doggyimage.transform = CGAffineTransform(scaleX: percentOffset.x/0.25, y: percentOffset.x/0.25)
            
        } else if(percentOffset.x > 0.25 && percentOffset.x <= 0.50) {
            slides[1].doggyimage.transform = CGAffineTransform(scaleX: (0.50-percentOffset.x)/0.25, y: (0.50-percentOffset.x)/0.25)
            slides[2].doggyimage.transform = CGAffineTransform(scaleX: percentOffset.x/0.50, y: percentOffset.x/0.50)
            
        } else if(percentOffset.x > 0.50 && percentOffset.x <= 0.75) {
            slides[2].doggyimage.transform = CGAffineTransform(scaleX: (0.75-percentOffset.x)/0.25, y: (0.75-percentOffset.x)/0.25)
            slides[3].doggyimage.transform = CGAffineTransform(scaleX: percentOffset.x/0.75, y: percentOffset.x/0.75)
            
        } else if(percentOffset.x > 0.75 && percentOffset.x <= 1) {
            slides[3].doggyimage.transform = CGAffineTransform(scaleX: (1-percentOffset.x)/0.25, y: (1-percentOffset.x)/0.25)
            slides[4].doggyimage.transform = CGAffineTransform(scaleX: percentOffset.x, y: percentOffset.x)
        }
    }
    
    
    
    
    
}
