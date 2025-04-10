//
//  AlertDetailsViewController.swift
//  VacunaT
//
//  Created by Aldo on 21/01/18.
//  Copyright © 2018 Aldo. All rights reserved.
//

import UIKit
import GoogleMobileAds

class AlertDetailsViewController: UIViewController {

    var notif = Notification()
    
    
    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var txtApplication: UITextView!
    @IBOutlet weak var txtSideEffects: UITextView!
    @IBOutlet weak var banner: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        txtName.text = notif.name
        txtApplication.text = notif.application
        txtSideEffects.text = notif.sideEffects
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
