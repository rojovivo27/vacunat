//
//  ProfileDetailsViewController.swift
//  Vacuna-T
//
//  Created by Aldo on 11/01/18.
//  Copyright © 2018 Aldo. All rights reserved.
//

import UIKit
import GoogleMobileAds
import SwiftyJSON
import UserNotifications

class ProfileDetailsViewController: UIViewController, GADInterstitialDelegate, GADRewardBasedVideoAdDelegate {
    
    var profileId = 0
    
    var interstitial: GADInterstitial!

    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var bDayPicker: UIDatePicker!
    @IBOutlet weak var genderSwitch: UISegmentedControl!
    @IBOutlet weak var pregnancyContainer: UIView!
    @IBOutlet weak var txtMonths: UITextField!
    @IBOutlet weak var monthsStepper: UIStepper!
    @IBOutlet weak var isPregnantSwitch: UISwitch!
    
    //Constraints
    @IBOutlet weak var avatarHConstraint: NSLayoutConstraint!
    @IBOutlet weak var avatarWConstraint: NSLayoutConstraint!
    @IBOutlet weak var pickerHConstraint: NSLayoutConstraint!
    
    var gender = "M"
    var isPregnant = false
    var pregnancyAge = 0
    
    //Notifications
    let center = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        // Swift
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                // Notifications not allowed
                let alert = UIAlertController(title: "Ooops", message: "Activa las notificaciones para que tu perfil te avise cuando tengas que atender nuevas vacunas y vuelve a lanzar la app", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Entendido", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tap)
        
        let profileCreated = UserDefaults.standard.bool(forKey: "ProfileCreated")
        if (!profileCreated) {
            btnCancel.isEnabled = false
        }
        pregnancyContainer.isHidden = true
        
        if (profileId != 0){
            let user = User.rowBy(id: profileId) as! User
            txtName.text = user.name
            bDayPicker.date = user.bDay
            genderSwitch.selectedSegmentIndex = user.gender == "M" ? 0 : 1
            gender = user.gender
            isPregnantSwitch.isOn = user.pregnancy
            isPregnant = user.pregnancy
            txtMonths.text = user.gestationalAge.description
            monthsStepper.value = Double(user.gestationalAge)
            pregnancyAge = user.gestationalAge
            checkAvatar()
            
            pregnancyContainer.isHidden = genderSwitch.selectedSegmentIndex == 0
        }
        
        //Interstitial
        createIntersticial()
        
        //Rewarded
        GADRewardBasedVideoAd.sharedInstance().delegate = self
        //GADRewardBasedVideoAd.sharedInstance().load(GADRequest(), withAdUnitID: "ca-app-pub-3940256099942544/1712485313") //Test
        GADRewardBasedVideoAd.sharedInstance().load(GADRequest(), withAdUnitID: "ca-app-pub-3383512806298757/5820699672") //Real
        
        //Constraints
        avatarHConstraint.constant = view.frame.height * 0.13
        avatarWConstraint.constant = view.frame.height * 0.13
        pickerHConstraint.constant = view.frame.height * 0.20
    }

    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        
        if (txtName.text?.isEmpty)!{
            let alert = UIAlertController(title: "Error", message: "Introduce el nombre del perfil", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Confirmación", message: "Los datos son correctos?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Continuar", style: .default, handler: { (action) in
                
                //Save data locally
                var user: User
                if(self.profileId == 0){//New User
                    user = User()
                    user.name = self.txtName.text!
                    user.bDay = self.bDayPicker.date
                    user.gender = self.gender
                    user.pregnancy = self.isPregnant
                    user.gestationalAge = self.pregnancyAge
                    _ = user.save()
                } else { //Existent User
                    user = User.rowBy(id: self.profileId) as! User
                    user.name = self.txtName.text!
                    user.bDay = self.bDayPicker.date
                    user.gender = self.gender
                    user.pregnancy = self.isPregnant
                    user.gestationalAge = self.pregnancyAge
                    _ = user.save()
                }
                
                //Delete previous LocalNotifications
                self.center.removePendingNotificationRequests(withIdentifiers: [String(describing: user.id)])
                self.center.removeDeliveredNotifications(withIdentifiers: [String(describing: user.id)])
                
                //Delete previous Notifications BD
                let notifications = Notification.rows(filter: "idUser=\(user.id)") as! [Notification]
                for notification in notifications {
                    _ = notification.delete()
                }
                
                //Set user category and age
                let components = NSCalendar.current.dateComponents([.month], from: user.bDay, to: Date())
                let ageInMonths = components.month!
                let pregnancy = user.pregnancy
                let gestationalAge = user.gestationalAge
                
                
                //Load Expert
                //Vaccines
                let path = Bundle.main.path(forResource: "vaccines", ofType: "json")
                let url = URL(fileURLWithPath: path!)
                do{
                    let data = try Data(contentsOf: url)
                    let vaccines = try JSON(data: data)
                    let info = vaccines["vacunas"].arrayValue.last
                    let list = info!["experto"].arrayValue
                    for vaccine in list {
                        if (
                            (vaccine["categoria"].stringValue != "Embarazada" && (ageInMonths - 2) <= vaccine["edad"].intValue)
                            || (vaccine["categoria"].stringValue == "Embarazada" && pregnancy && (gestationalAge - 2) <= vaccine["edad"].intValue)
                            || (vaccine["categoria"].stringValue == "Bebe" && ageInMonths <= vaccine["limite"].intValue && vaccine["anual"].stringValue == "Si")
                            || (vaccine["categoria"].stringValue == "Adulto" && vaccine["anual"].stringValue == "Si")
                            ) {
                            
                            print(vaccine["nombre"].stringValue)
                            
                            //Create Notifications to Database
                            let notification = Notification()
                            notification.name = vaccine["nombre"].stringValue
                            notification.idUser = user.id
                            notification.category = vaccine["categoria"].stringValue
                            notification.months = vaccine["edad"].intValue
                            notification.application = vaccine["indicaciones"].stringValue
                            notification.sideEffects = vaccine["contraindicaciones"].stringValue
                            notification.isAnual = vaccine["anual"].stringValue == "Si"
                            
                            let months = notification.category == "Embarazada" ? (notification.months - user.gestationalAge) : notification.months
                            let vaccinateDate = Calendar.current.date(byAdding: .month, value: months, to: notification.category == "Embarazada" ? Date() : user.bDay)
                            let notificationDate = Calendar.current.date(byAdding: .day, value: -7, to: vaccinateDate!)
                            let aMonthAgo = Calendar.current.date(byAdding: .month, value: -1, to: Date())
                            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())
                            
                            notification.estimatedDate = vaccinateDate! > Date() ? vaccinateDate! : tomorrow!
                            
                            _ = notification.save()
                            
                            //Date Formatter
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "dd MMM yyyy"
                            
                            //Crear notificaciones
                            if(notification.isAnual){
                                if(notification.category == "Bebe"){
                                    let limit = vaccine["limite"].intValue
                                    let periods = Int(ceil(Double(limit - ageInMonths) / 12.0))
                                    for n in 1...periods {
                                        
                                        print("Creada la notificación de la vacuna \(notification.name), de la categoría \(notification.category) para: \(user.name), que le toca cada año al iniciar las campañas de vacunación. La notificación se mostrará el día 1ro de Octubre")
                                        
                                        let content = UNMutableNotificationContent()
                                        content.title = "Vacuna para: \(user.name)"
                                        content.body = "La vacuna: \(notification.name), está programada para el día: \(dateFormatter.string(from: vaccinateDate!))"
                                        var triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: notificationDate!)
                                        triggerDate.month = 10
                                        triggerDate.year = triggerDate.year! + (n-1)
                                        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
                                        let identifier = String(describing: user.id)
                                        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                                        self.center.add(request, withCompletionHandler: { (error) in
                                            if let error = error {
                                                // Something went wrong
                                                print("Error: \(error)")
                                            }
                                        })
                                    }
                                } else {
                                    print("Creada la notificación de la vacuna \(notification.name), de la categoría \(notification.category) para: \(user.name), que le toca cada año al iniciar las campañas de vacunación. La notificación se mostrará el día 1ro de Octubre")
                                    let content = UNMutableNotificationContent()
                                    content.title = "Vacuna para: \(user.name)"
                                    content.body = "La vacuna: \(notification.name), está programada para el día: \(dateFormatter.string(from: vaccinateDate!))"
                                    var triggerYearly = Calendar.current.dateComponents([.month, .day, .hour, .minute, .second], from: Date())
                                    triggerYearly.month = 10
                                    let trigger = UNCalendarNotificationTrigger(dateMatching: triggerYearly, repeats: true)
                                    let identifier = String(describing: user.id)
                                    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                                    self.center.add(request, withCompletionHandler: { (error) in
                                        if let error = error {
                                            // Something went wrong
                                            print("Error: \(error)")
                                        }
                                    })
                                }
                            } else {
                                if(notificationDate! >= Date()){
                                    print("Creada la notificación de la vacuna \(notification.name), de la categoría \(notification.category) para: \(user.name), que le toca aproximadamente el día \(vaccinateDate!). La notificación se mostrará el día \(notificationDate!)")
                                    
                                    let content = UNMutableNotificationContent()
                                    content.title = "Vacuna para: \(user.name)"
                                    content.body = "La vacuna: \(notification.name), está programada para el día: \(dateFormatter.string(from: vaccinateDate!))"
                                    let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: notificationDate!)
                                    let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
                                    let identifier = String(describing: user.id)
                                    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                                    self.center.add(request, withCompletionHandler: { (error) in
                                        if let error = error {
                                            // Something went wrong
                                            print("Error: \(error)")
                                        }
                                    })
                                } else if(notificationDate! >= aMonthAgo!){
                                    print("Creada la notificación de la vacuna \(notification.name), de la categoría \(notification.category) para: \(user.name), que le toca aproximadamente el día \(vaccinateDate!). La notificación se mostrará el día \(tomorrow!)")
                                    
                                    let content = UNMutableNotificationContent()
                                    content.title = "Vacuna para: \(user.name)"
                                    content.body = "La vacuna: \(notification.name), está programada para el día: \(dateFormatter.string(from: vaccinateDate!))"
                                    let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: tomorrow!)
                                    let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
                                    let identifier = String(describing: user.id)
                                    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                                    self.center.add(request, withCompletionHandler: { (error) in
                                        if let error = error {
                                            // Something went wrong
                                            print("Error: \(error)")
                                        }
                                    })
                                }
                            }
                            //Create Local Notifications to OS
                            /*let content = UNMutableNotificationContent()
                             content.title = "Don't forget"
                             content.body = "Buy some milk"
                             content.sound = UNNotificationSound.default()
                             let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 300,
                             repeats: false)
                             */
                        }
                    }
                    
                } catch {
                    print(error)
                }
                
                UserDefaults.standard.set(true, forKey: "ProfileCreated")
                
                if self.interstitial.isReady{
                    self.interstitial.present(fromRootViewController: self)
                    if (GADRewardBasedVideoAd.sharedInstance().isReady) {
                        GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self)
                    }
                } else {
                    print("ad wasn't ready")
                    self.dismiss(animated: true, completion: nil)
                }

            }))
            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func genderSelected(_ sender: UISegmentedControl) {
        gender = sender.selectedSegmentIndex == 0 ? "M" : "F"
        pregnancyContainer.isHidden = sender.selectedSegmentIndex == 0
        if(sender.selectedSegmentIndex == 0){
            isPregnantSwitch.isOn = false
            monthsStepper.value = 1
            txtMonths.text = "1"
        }
        checkAvatar()
    }
    
    @IBAction func bDaySelected(_ sender: UIDatePicker) {
        checkAvatar()
    }
    
    func checkAvatar(){
        let components = NSCalendar.current.dateComponents([.year], from: bDayPicker.date, to: Date())
        let years = components.year
        if(gender == "M"){//vatillo
            if(years! <= 3){
                imgAvatar.image = UIImage(named: "006-baby")
            } else if (years! > 3 && years! < 18) {
                imgAvatar.image = UIImage(named: "004-boy")
            } else if (years! >= 18 && years! < 60) {
                imgAvatar.image = UIImage(named: "007-man")
            } else if (years! >= 60) {
                imgAvatar.image = UIImage(named: "002-old-man")
            }
        } else { //morriona
            if(years! <= 3){
                imgAvatar.image = UIImage(named: "005-baby-1")
            } else if (years! > 3 && years! < 18) {
                imgAvatar.image = UIImage(named: "003-girl")
            } else if (years! >= 18 && years! < 60) {
                imgAvatar.image = UIImage(named: "008-girl-1")
            } else if (years! >= 60) {
                imgAvatar.image = UIImage(named: "001-old-woman")
            }
        }
    }
    
    @IBAction func pregnancySelected(_ sender: UISwitch) {
        isPregnant = sender.isOn
        monthsStepper.isEnabled = sender.isOn
    }
    
    @IBAction func gestationalAgeSelected(_ sender: UIStepper) {
        pregnancyAge = Int(sender.value)
        txtMonths.text = pregnancyAge.description
    }
    
    func createIntersticial(){
        //Test ID: ca-app-pub-3940256099942544/4411468910
        //Real ID: ca-app-pub-3383512806298757/9203419872
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3383512806298757/9203419872")
        let request = GADRequest()
        interstitial.load(request)
        interstitial.delegate = self
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
        self.dismiss(animated: true, completion: nil)
    }
    
    /// Tells the delegate that a user click will open another app
    /// (such as the App Store), backgrounding the current app.
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        print("interstitialWillLeaveApplication")
    }
    
    // REWARDED
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didRewardUserWith reward: GADAdReward) {
        print("Reward received with currency: \(reward.type), amount \(reward.amount).")
    }
    
    func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd:GADRewardBasedVideoAd) {
        print("Reward based video ad is received.")
    }
    
    func rewardBasedVideoAdDidOpen(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Opened reward based video ad.")
    }
    
    func rewardBasedVideoAdDidStartPlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad started playing.")
    }
    
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad is closed.")
        //GADRewardBasedVideoAd.sharedInstance().load(GADRequest(), withAdUnitID: "ca-app-pub-3940256099942544/1712485313") //Test
        GADRewardBasedVideoAd.sharedInstance().load(GADRequest(), withAdUnitID: "ca-app-pub-3383512806298757/5820699672") //Real
    }
    
    func rewardBasedVideoAdWillLeaveApplication(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad will leave application.")
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didFailToLoadWithError error: Error) {
        print("Reward based video ad failed to load.")
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
