//
//  CartillaViewController.swift
//  VacunaT
//
//  Created by Aldo on 16/01/18.
//  Copyright © 2018 Aldo. All rights reserved.
//

import UIKit
import GoogleMobileAds

class CartillaViewController: UIViewController {
    
    @IBOutlet weak var banner: GADBannerView!
    @IBOutlet weak var btnBaby: UIView!
    @IBOutlet weak var btnAdult: UIView!
    
    var type = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        btnBaby.layer.cornerRadius = 10
        btnAdult.layer.cornerRadius = 10
        
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
    
    @IBAction func showBaby(_ sender: UIButton) {
        type = 1
        performSegue(withIdentifier: "cartilla", sender: self)
    }
    
    @IBAction func showTeen(_ sender: UIButton) {
        type = 2
        performSegue(withIdentifier: "cartilla", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! CartillaDetailsViewController
        destination.type = type
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    */

}
