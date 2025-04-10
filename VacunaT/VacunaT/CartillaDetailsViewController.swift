//
//  CartillaDetailsViewController.swift
//  VacunaT
//
//  Created by Aldo on 17/01/18.
//  Copyright © 2018 Aldo. All rights reserved.
//

import UIKit
import GoogleMobileAds

class CartillaDetailsViewController: UIViewController, UIScrollViewDelegate {

    
    @IBOutlet weak var banner: GADBannerView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    var type = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mainScrollView.delegate = self
        mainScrollView.minimumZoomScale = 1.0
        mainScrollView.maximumZoomScale = 3.0
        
        imageView.image = UIImage(named: type == 1 ? "kids" : "adults")
        
        //Banner
        //Test ID: ca-app-pub-3940256099942544/2934735716
        //Real ID: ca-app-pub-3383512806298757/4946989400
        banner.adUnitID = "ca-app-pub-3383512806298757/4946989400"
        banner.rootViewController = self
        
        banner.load(GADRequest())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
