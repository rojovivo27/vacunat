//
//  ViewController.swift
//  Vacuna-T
//
//  Created by Aldo on 04/11/17.
//  Copyright © 2017 Aldo. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewController: UIViewController, GADInterstitialDelegate {

    @IBOutlet weak var banner: GADBannerView!
    var interstitial: GADInterstitial!
    
    @IBOutlet weak var btnBaby: UIButton!
    @IBOutlet weak var btnTeen: UIButton!
    @IBOutlet weak var btnMom: UIButton!
    @IBOutlet weak var btnOld: UIButton!
    
    var peopleType = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        btnBaby.imageView?.contentMode = .scaleAspectFit
        btnBaby.layer.cornerRadius = 10
        btnTeen.imageView?.contentMode = .scaleAspectFit
        btnTeen.layer.cornerRadius = 10
        btnMom.imageView?.contentMode = .scaleAspectFit
        btnMom.layer.cornerRadius = 10
        btnOld.imageView?.contentMode = .scaleAspectFit
        btnOld.layer.cornerRadius = 10
        
        //Banner
        //Test ID: ca-app-pub-3940256099942544/2934735716
        //Real ID: ca-app-pub-3383512806298757/4946989400
        banner.adUnitID = "ca-app-pub-3383512806298757/4946989400"
        banner.rootViewController = self
        
        banner.load(GADRequest())
        
        //Interstitial
        //createIntersticial()
        
        let dontShowAgain = UserDefaults.standard.bool(forKey: "DontShowAgain")
        if !dontShowAgain {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "onboarding", sender: self)
            }
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    func createIntersticial(){
        //Test ID: ca-app-pub-3940256099942544/4411468910
        //Real ID: ca-app-pub-3383512806298757/9203419872
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        let request = GADRequest()
        interstitial.load(request)
        interstitial.delegate = self
    }
     */
    
    @IBAction func showBaby(_ sender: UIButton) {
        peopleType = 1
        self.performSegue(withIdentifier: "vaccinates", sender: self)
        /*if interstitial.isReady{
            interstitial.present(fromRootViewController: self)
        } else {
            print("ad wasn't ready")
            //createIntersticial()
            self.performSegue(withIdentifier: "vaccinates", sender: self)
        }*/
    }
    
    @IBAction func showTeen(_ sender: UIButton) {
        peopleType = 2
        self.performSegue(withIdentifier: "vaccinates", sender: self)
        /*if interstitial.isReady{
         interstitial.present(fromRootViewController: self)
         } else {
         print("ad wasn't ready")
         //createIntersticial()
         self.performSegue(withIdentifier: "vaccinates", sender: self)
         }*/
    }
    
    @IBAction func showMom(_ sender: UIButton) {
        peopleType = 3
        self.performSegue(withIdentifier: "vaccinates", sender: self)
        /*if interstitial.isReady{
         interstitial.present(fromRootViewController: self)
         } else {
         print("ad wasn't ready")
         //createIntersticial()
         self.performSegue(withIdentifier: "vaccinates", sender: self)
         }*/    }
    
    @IBAction func showOld(_ sender: UIButton) {
        peopleType = 4
        self.performSegue(withIdentifier: "vaccinates", sender: self)
        /*if interstitial.isReady{
         interstitial.present(fromRootViewController: self)
         } else {
         print("ad wasn't ready")
         //createIntersticial()
         self.performSegue(withIdentifier: "vaccinates", sender: self)
         }*/
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "vaccinates"){
            let vc = segue.destination as! VaccinateListViewController
            vc.peopleType = self.peopleType
        }
    }
    
    
    ///INTERSTITIAL
    
    /// Tells the delegate an ad request succeeded.
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("interstitialDidReceiveAd")
    }
    
    /// Tells the delegate an ad request failed.
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that an interstitial will be presented.
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        print("interstitialWillPresentScreen")
    }
    
    /// Tells the delegate the interstitial is to be animated off the screen.
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        print("interstitialWillDismissScreen")
    }
    
    /// Tells the delegate the interstitial had been animated off the screen.
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        print("interstitialDidDismissScreen")
        self.performSegue(withIdentifier: "vaccinates", sender: self)
    }
    
    /// Tells the delegate that a user click will open another app
    /// (such as the App Store), backgrounding the current app.
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        print("interstitialWillLeaveApplication")
    }

}

