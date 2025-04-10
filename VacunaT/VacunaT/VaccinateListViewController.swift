//
//  VaccinateListViewController.swift
//  Vacuna-T
//
//  Created by Aldo on 04/11/17.
//  Copyright © 2017 Aldo. All rights reserved.
//

import UIKit
import GoogleMobileAds
import SwiftyJSON

class VaccinateListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var headerBanner: GADBannerView!
    @IBOutlet weak var bottomBanner: GADBannerView!
    @IBOutlet weak var tableView: UITableView!
    
    var peopleType = 0
    var rawDescription = ""
    var vaccinate = ""
    var age = ""
    var category = ""
    
    
    var vaccinates = [InfoVaccinate]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var customTitle = ""
        switch peopleType {
        case 1:
            customTitle = "Vacunas para Bebés"
            category = "Bebe"
        case 2:
            customTitle = "Vacunas para Adolescentes"
            category = "Adolescente"
        case 3:
            customTitle = "Vacunas para Embarazo"
            category = "Embarazada"
        case 4:
            customTitle = "Vacunas para 3ra Edad"
            category = "Adulto"
        default:
            customTitle = ""
        }
        
        self.title = customTitle
        
        //Vaccines
        let path = Bundle.main.path(forResource: "vaccines", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        
        do{
            let data = try Data(contentsOf: url)
            let vaccines = try JSON(data: data)
            let info = vaccines["vacunas"].arrayValue.first
            let list = info!["informativas"].arrayValue
            for vaccine in list {
                if (vaccine["categorias"].stringValue == self.category){
                    self.vaccinates.append(InfoVaccinate(name: vaccine["nombre"].stringValue, details: vaccine["descripcion"].stringValue, age: vaccine["edad"].stringValue))
                }
            }
            tableView.reloadData()
            
        } catch {
            print(error)
        }
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vaccinates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "vaccinate")
        cell?.textLabel?.text = vaccinates[indexPath.row].name
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rawDescription = vaccinates[indexPath.row].details
        vaccinate = vaccinates[indexPath.row].name
        age = vaccinates[indexPath.row].age
        performSegue(withIdentifier: "details", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! VaccinateDetailViewController
        vc.vaccinate = vaccinate
        vc.rawDescription = rawDescription
        vc.age = age
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
