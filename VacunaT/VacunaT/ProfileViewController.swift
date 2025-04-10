//
//  ProfileViewController.swift
//  Vacuna-T
//
//  Created by Aldo on 11/01/18.
//  Copyright © 2018 Aldo. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ProfileViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var action = 0
    var profileID = 0
    var profiles = [User]()
    
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var profilePicker: UIPickerView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAge: UILabel!
    @IBOutlet weak var lblGestationalAge: UILabel!
    
    @IBOutlet weak var banner: GADBannerView!
    
    //Constraints
    @IBOutlet weak var avatarHConstraint: NSLayoutConstraint!
    @IBOutlet weak var avatarWConstraint: NSLayoutConstraint!
    @IBOutlet weak var pickerHConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        profilePicker.dataSource = self
        profilePicker.delegate = self
        
        //Banner
        //Test ID: ca-app-pub-3940256099942544/2934735716
        //Real ID: ca-app-pub-3383512806298757/4946989400
        banner.adUnitID = "ca-app-pub-3383512806298757/4946989400"
        banner.rootViewController = self
        
        banner.load(GADRequest())
        
        //Constraints
        avatarHConstraint.constant = view.frame.height * 0.13
        avatarWConstraint.constant = view.frame.height * 0.13
        pickerHConstraint.constant = view.frame.height * 0.20
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let profileCreated = UserDefaults.standard.bool(forKey: "ProfileCreated")
        if (!profileCreated) {
            action = 1
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "createProfile", sender: self)
            }
        } else {
            profiles = User.rows() as! [User]
            profilePicker.reloadAllComponents()
            profilePicker.selectRow(0, inComponent: 0, animated: true)
            profileID = (profiles.first?.id)!
            
            updateUI(id: profileID)
        }
    }

    func updateUI(id: Int){
        //Update UI
        let profile = User.rowBy(id: profileID) as! User
        let components = NSCalendar.current.dateComponents([.year], from: profile.bDay, to: Date())
        
        let years = components.year
        if(profile.gender == "M"){//vatillo
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
        lblName.text = profile.name
        
        lblAge.text = "\(String(describing: years!)) años"
        lblGestationalAge.text = "\(String(describing: profile.gestationalAge)) meses de embarazo"
        lblGestationalAge.isHidden = !(profile.pregnancy)
    }
    
    @IBAction func addProfile(_ sender: Any) {
        action = 1
        performSegue(withIdentifier: "createProfile", sender: self)
    }
    
    @IBAction func editProfile(_ sender: UIButton) {
        action = 2
        performSegue(withIdentifier: "createProfile", sender: self)
    }
    
    @IBAction func deleteProfile(_ sender: UIButton) {
        if(profiles.count > 1){
            
            let profile = User.rowBy(id: profileID) as! User
            var title = ""
            var message = ""
            let alerts = Notification.rows(filter: "idUser = \(profileID)") as! [Notification]
            for alert in alerts {
                _ = alert.delete()
            }
            if(profile.delete()){
                title = "Éxito"
                message = "El perfil ha sido eliminado"
            } else {
                title = "Error"
                message = "Hay un error al tratar de eliminar el perfil, inténtalo más tarde"
            }
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Entendido", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            profiles = User.rows() as! [User]
            profilePicker.reloadAllComponents()
            profilePicker.selectRow(0, inComponent: 0, animated: true)
            profileID = (profiles.first?.id)!
            
            updateUI(id: profileID)
        } else {
            let alert = UIAlertController(title: "Error", message: "No puedes eliminar el último perfil", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Entendido", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ProfileDetailsViewController
        if(action == 2){
            destination.profileId = profileID
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return profiles.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let name = profiles[row].name
        return name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        profileID = profiles[row].id
        updateUI(id: profileID)
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
