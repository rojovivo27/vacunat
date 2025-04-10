//
//  AlertsViewController.swift
//  VacunaT
//
//  Created by Aldo on 17/01/18.
//  Copyright © 2018 Aldo. All rights reserved.
//

import UIKit
import GoogleMobileAds

class AlertsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var profilePicker: UIPickerView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var headerBanner: GADBannerView!
    @IBOutlet weak var bottomBanner: GADBannerView!
    @IBOutlet weak var imgAvatar: UIImageView!
    
    var profileID = 0
    var profiles = [User]()
    var newAlerts = [Notification]()
    var pastAlerts = [Notification]()
    
    var section = 0
    var index = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        profilePicker.dataSource = self
        profilePicker.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self

        // Do any additional setup after loading the view.
        //Banners
        //Test ID: ca-app-pub-3940256099942544/2934735716
        //Real ID: ca-app-pub-3383512806298757/4946989400
        headerBanner.adUnitID = "ca-app-pub-3383512806298757/4946989400"
        headerBanner.rootViewController = self
        headerBanner.load(GADRequest())
        
        bottomBanner.adUnitID = "ca-app-pub-3383512806298757/4946989400"
        bottomBanner.rootViewController = self
        bottomBanner.load(GADRequest())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let profileCreated = UserDefaults.standard.bool(forKey: "ProfileCreated")
        if (!profileCreated) {
            let alert = UIAlertController(title: "Alerta", message: "Debes crear al menos un perfil para poder revisar las notificaciones", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            profiles = User.rows() as! [User]
            profilePicker.reloadAllComponents()
            profilePicker.selectRow(0, inComponent: 0, animated: true)
            profileID = (profiles.first?.id)!
            
            newAlerts = Notification.rows(filter: "idUser = \(profileID) AND done = 0", order: "months asc", limit: 5) as! [Notification]
            pastAlerts = Notification.rows(filter: "idUser = \(profileID) AND done = 1", order: "months asc", limit: 5) as! [Notification]
            tableView.reloadData()
            if(profiles.count > 0){
                updatePicture(index: 0)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updatePicture(index: Int){
        let profile = profiles[index]
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
    }
    
    //PICKER VIEW
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
        if(profiles.count > 0){
            profileID = profiles[row].id
            newAlerts = Notification.rows(filter: "idUser = \(profileID) AND done = 0", order: "months asc", limit: 5) as! [Notification]
            pastAlerts = Notification.rows(filter: "idUser = \(profileID) AND done = 1", order: "months asc", limit: 5) as! [Notification]
            tableView.reloadData()
            updatePicture(index: row)
        }
    }

    //TABLE VIEW
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0){
            return "Próximas vacunas"
        } else {
            return "Vacunas recientes"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return newAlerts.count
        } else {
            return pastAlerts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        if(indexPath.section == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "new") as! NewTableViewCell
            cell.txtVaccinate.text = newAlerts[indexPath.row].name
            let estimatedDate = dateFormatter.string(from: newAlerts[indexPath.row].estimatedDate)
            cell.txtDueTo.text = "Estimada para el: \(estimatedDate)"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "old") as! OldTableViewCell
            cell.txtVaccinate.text = pastAlerts[indexPath.row].name
            let estimatedDate = dateFormatter.string(from: pastAlerts[indexPath.row].receivedOn)
            cell.txtReceivedOn.text = "Tomada el: \(estimatedDate)"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        section = indexPath.section
        index = indexPath.row
        
        performSegue(withIdentifier: "details", sender: self)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if(indexPath.section == 0){
            let editAction = UITableViewRowAction(style: .normal, title: "Realizada") { (rowAction, indexPath) in
                //TODO: edit the row at indexPath here
                print("Marcar como realizada")
                let notification = self.newAlerts[indexPath.row]
                notification.done = true
                notification.receivedOn = Date()
                _ = notification.save()
                
                //Update
                self.newAlerts = Notification.rows(filter: "idUser = \(self.profileID) AND done = 0", order: "months asc", limit: 5) as! [Notification]
                self.pastAlerts = Notification.rows(filter: "idUser = \(self.profileID) AND done = 1", order: "months asc", limit: 5) as! [Notification]
                self.tableView.reloadData()
                
            }
            editAction.backgroundColor = .green
            return [editAction]
        } else {
            let editAction = UITableViewRowAction(style: .normal, title: "") { (rowAction, indexPath) in
            }
            editAction.backgroundColor = .white
            return [editAction]
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! AlertDetailsViewController
        destination.notif = section == 0 ? (newAlerts[index]) : (pastAlerts[index])
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

class NewTableViewCell: UITableViewCell{
    @IBOutlet weak var txtVaccinate: UILabel!
    @IBOutlet weak var txtDueTo: UILabel!
    
}


class OldTableViewCell: UITableViewCell{
    @IBOutlet weak var txtVaccinate: UILabel!
    @IBOutlet weak var txtReceivedOn: UILabel!
}
